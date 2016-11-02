#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 2;

system q(export PERLLIB=/home_soft/soft/x86_64/lib/Perl/module/lib64/perl5/site_perl/5.8.8/x86_64-linux-thread-multi${PERLLIB:+:$PERLLIB});
##Algorithm-Cluster-1.50
system q(export PERLLIB=/home_soft/soft/x86_64/lib/Perl/module/lib/perl5/site_perl/5.8.8${PERLLIB:+:$PERLLIB});
##Algorithm-Cluster-Thresh-0.05
system q(export PERLLIB=/home_soft/soft/x86_64/lib/Perl/module/lib/perl5/5.8.8${PERLLIB:+:$PERLLIB});
##ExtUtils-MakeMaker-6.62(for install some new modules)
system q(export PERLLIB=/home_soft/soft/x86_64/lib/Perl/module/lib/perl5/site_perl/5.8.8${PERLLIB:+:$PERLLIB});
##IPC-Run-0.92(for Statistics-R-0.27)
system q(export PERLLIB=/home_soft/soft/x86_64/lib/Perl/module/lib/perl5/site_perl/5.8.8${PERLLIB:+:$PERLLIB});
##Regexp-Common-2011121001(for Statistics-R-0.27)
system q(export PERLLIB=/home_soft/soft/x86_64/lib/Perl/module/lib/perl5/5.8.8${PERLLIB:+:$PERLLIB});
##Text-Balanced-2.02(for Statistics-R-0.27)
system q(export PERLLIB=/home_soft/soft/x86_64/lib/Perl/module/lib/perl5/site_perl/5.8.8${PERLLIB:+:$PERLLIB});
## Statistics-R-0.27

print "done\n";
use Algorithm::Cluster qw/treecluster/;
use Algorithm::Cluster::Thresh;
use Statistics::R;
my ($marker,$out) = @ARGV;
open MARK,$marker or die "$!";
open OUT,"+>tem_ped2geno.txt" or die "$!";
my @head;
while(<MARK>){
    chomp;
    my ($fam,$inbred,$non1,$non2,$non3,$non4,@geno) = split(/\t/); 
    my $tem_geno = join("\t",@geno);
       $tem_geno =~ s/1 1/1/g;
       $tem_geno =~ s/2 2/2/g;
       $tem_geno =~ s/3 3/3/g;
       $tem_geno =~ s/4 4/4/g;
       $tem_geno =~ s/0 0/NaN/g;
    print OUT "$inbred\t$tem_geno\n";
    push @head, $inbred;
}
close OUT;

my $R = Statistics::R ->new();
my $cmd = <<EOF;
library(scrime)
snp<-read.table("tem_ped2geno.txt")
rownames(snp)<-snp[,1]
snp<-subset(snp,select = -V1)
snp<-as.matrix(snp)
snp_sm <- smc(snp, dist = TRUE)
EOF
my $run = $R ->run($cmd);
my $date = `date`;
print "calculating distance :Done!",$date," !!\n";

open OUT1, "+>$out" or die "$!";
my $distmatrix = [[]];
for(my $i = 0;$i < @head;++$i){
    my @tem_dis = ();
    for(my $j = 1;$j <= @head;++$j){
        my $row = $i + 1;
        my $res = $R -> get("snp_sm[$row,$j]");  # row colum
        push @tem_dis,$res;
    }
    my $tem_dis = join("\t",@tem_dis);
    print OUT1 "$head[$i]\t$tem_dis\n";
#    print "Retrieve the data: $i Done !!\n";
}

sub usage{
    my $die =<<DIE;
    perl *.pl <marker> <output> 
DIE
}
