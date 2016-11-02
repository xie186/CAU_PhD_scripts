#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==3;
my ($gene_pos,$imp,$non_code) = @ARGV;

open IMP,$imp or die "$!";
my %hash_imp;
while(<IMP>){
    chomp;
    my ($gene_id,$status) = split;
    $hash_imp{$gene_id} = $status;
}

my %hash_snp;
open POS,$gene_pos or die "$!";
while(<POS>){
    chomp;
    my ($chr,$stt,$end,$gene) = split;
    next if $chr !~/\d/;
#    $chr = "chr".$chr if !/^chr/;
#    print "$chr\t$stt\t$end\n" if exists $hash_imp{$gene};
    if(exists $hash_imp{$gene}){
        $hash_snp{$chr} -> {$stt} = $_."\t$hash_imp{$gene}"."\n";
    }else{

    }
}

open NON,$non_code or die "$!";
while(<NON>){
    chomp;
    my ($chr,$stt,$end,$gene_id) = split;
#    $chr = "chr".$chr if !/^chr/;
    $hash_snp{$chr}->{$stt} = $_."\n" ;
}

my $cluster_size = 5000000;
my $clus_num = 1;
foreach my $chr (keys %hash_snp){
     my @pos = sort {$a<=>$b} (keys %{$hash_snp{$chr}});
     my $num = @pos;
     for(my $i =0;$i < $num; ++$i){
         my $stt1 = $pos[$i];
         my $tem_gene1 = $hash_snp{$chr} -> {$stt1};
          ($chr,$stt1, my $end1, my $gene_id1) = split(/\t/,$tem_gene1);
         next if $end1 - $stt1 + 1 > $cluster_size;
         my @gene;
         push @gene, $tem_gene1;
         PATH:{
             if(!$pos[$i + 1]){
                 if ($end1 - $stt1 <= $cluster_size && @gene > 1){
                     my $nu = @gene;
                     my $tem_ge = shift @gene;
                     print "cluster$clus_num\t$chr\t$stt1\t$end1\t$nu\t$tem_ge";
                     ++ $clus_num ;
                     foreach my $tem_gene_pos(@gene){
                         print "\t\t\t\t\t$tem_gene_pos";
                     }
                 }
             }else{
                 $i+=1;
                 my $stt2 = $pos[$i];
                 my $tem_gene2 = $hash_snp{$chr} -> {$stt2};
                 ($chr,$stt2, my $end2, my $gene_id2) = split(/\t/,$tem_gene2);
                 if($end2 - $stt1 + 1 <= $cluster_size){
                     $end1 = $end2;
                     push @gene, $tem_gene2;
                     redo PATH;
                 }else{
                     if(@gene > 1){
                         my $nu = @gene;
                         my $tem_ge = shift @gene;
                         print "cluster$clus_num\t$chr\t$stt1\t$end1\t$nu\t$tem_ge"; 
                         ++ $clus_num ;
                         foreach my $tem_gene_pos(@gene){
                             print "\t\t\t\t\t$tem_gene_pos";
                         }
                     }
                     @gene =();
                     push @gene,$tem_gene2;
#	             last if !$pos[$i];
                     $stt1 = $stt2;
                     $end1 = $end2;
                     redo PATH;
                 }
             }
         } 
     }
}

sub usage{
    print <<DIE;
    perl *.pl <gene position> <imp gene name> <non code> 
DIE
    exit 1;
}
