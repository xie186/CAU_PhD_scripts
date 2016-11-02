#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==1;

my ($ge_pos)=@ARGV;
open POS,$ge_pos or die "$!";
my @aa;my %rpkm;
while(<POS>){
    chomp;
    my ($chr,$stt1,$end1,$name,$strand,$type,$clas,$rpkm)=(split);
    next if $rpkm == 0;
    push (@aa,$rpkm) if !exists $rpkm{$name};
    $rpkm{$name}=$rpkm;
}
close POS;

my $for_r=join(',',@aa);
open OUT,"+>quantile.R" or die "$!";
print OUT "cc<-c($for_r)\nquantile(cc,probs=seq(0,1,0.2))";
my $quantile=`R --vanilla --slave <quantile.R`;
my ($fir,$sec,$thir,$four,$five)=(split(/\s+/,$quantile))[-5,-4,-3,-2,-1];
print "##\t$fir\t$sec\t$thir\t$four\t$five\n";

open POS,$ge_pos or die "$!";
while(<POS>){
    chomp;
    my @tem=(split);
    my ($chr,$stt1,$end1,$name,$strand,$type,$clas,$rp)=@tem;
    my $print=join("\t",@tem);
    if($rp > 0 && $rp<$fir){
        print "$print\t1\n";
    }elsif($rp>=$fir && $rp<=$sec){
        print "$print\t2\n";
    }elsif($rp>$sec && $rp<=$thir){
        print "$print\t3\n";
    }elsif($rp>$thir && $rp<=$four){
        print "$print\t4\n";
    }elsif($rp>$four && $rp<=$five){
        print "$print\t5\n";
    }elsif($rp == 0){
        print "$print\t0\n";
    }
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Genepos_FGS with categories>
    Rank to Six groups based on gene expression level.
DIE
}
