#!/usr/bin/perl -w
use strict;
use Algorithm::Cluster qw/treecluster/;
use Algorithm::Cluster::Thresh;
use Statistics::R;
use Data::Dumper;
die usage() unless @ARGV == 4;
my ($gene_ped,$inbred_nu,$cut,$out) = @ARGV;
open PED,$gene_ped or die "$!";
open OUT,"+>$out" or die "$!";

my $R = Statistics::R ->new();
my @ped = <PED>;
my $gene_nu = ($#ped+1)/$inbred_nu;
for(my $i = 1; $i <= $gene_nu;++$i){
    open TEM,"+>$gene_ped.R" or die "$!";
    my @head;
    my $gene_name;
    for(my $j = 1;$j <=$inbred_nu;++$j){
        my $line = shift @ped;
        my ($tem_name,@geno) = split(/\t/,$line);
           $gene_name = $tem_name;
        push @head, $geno[0];
        my $tem_join = join("\t",@geno);
        print TEM "$tem_join";
     }
     close TEM;
     my $cmd = <<EOF;
library(scrime)
snp<-read.table("$gene_ped.R")
rownames(snp)<-snp[,1]
snp<-subset(snp,select = -V1)
snp<-as.matrix(snp)
snp_sm <- smc(snp, dist = TRUE)
EOF
       print "calculating distance!!!\n";
       $R ->run($cmd);
       print "Done!!!\n";
       my $distmatrix = [[]];
       for(my $i = 0;$i < @head;++$i){
           my @tem_dis = ();
            for(my $j = 1;$j <= $i;++$j){
                my $row = $i + 1;
                my $res = $R -> get("snp_sm[$row,$j]");  # row colum
                push @tem_dis,$res;
            }
            push @{$$distmatrix[$i]}, @tem_dis;
       }
       print "Retrieve the distance matrix!!! DONE\n";
    #     print "Retrieve the data: $i Done !!\n";
       print "Clustering\t go go go",time ,"\n";
       my $tree = treecluster(data=>$distmatrix, method=>'s'); # 'a'verage linkage
       # Get your objects and the cluster IDs they belong to
        # Clusters are within 5.5 of each other (based on average linkage here)
       my $cluster_ids = $tree->cutthresh($cut);
       print "Clustering\t go go go", time,"\n";
            # Index corresponds to that of the original objects
       my %hash_group;
       my %hash_ge_nu;
       foreach(my $i = 0;$i < @head;++$i ){
           my $group_nu = $cluster_ids->[$i];
       	   push @{$hash_group{$group_nu}} , $head[$i];
       	   $hash_ge_nu{$group_nu} ++;
	}

      foreach my $group_nu(sort {$hash_ge_nu{$b}<=> $hash_ge_nu{$a}} keys %hash_ge_nu){
	    my $inbred = join("-",@{$hash_group{$group_nu}});
	    my $inbred_nu = @head;
	    my $perc = $hash_ge_nu{$group_nu} / $inbred_nu;
            print OUT "$gene_name\t$group_nu\t$hash_ge_nu{$group_nu}\t$perc\t$inbred_nu\t$inbred\n";
      }
      print "$gene_name: $i Done!!!\n";
}
$R->stopR();
close OUT;
sub usage{
    my $die=<<DIE;
    perl *.pl <marker input> <Inbred number> <cut threshold>  <out> 
DIE
}
