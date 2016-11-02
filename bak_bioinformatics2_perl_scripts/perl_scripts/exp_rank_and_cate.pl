#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==2;

my ($rpkm,$genepos)=@ARGV;
open POS,$genepos or die "$!";
my %gene;
while(<POS>){
    chomp;
    my ($chr,$stt1,$end1,$name,$strand,$cate)=split;
    $gene{$name}=$_;
}

open RPKM,$rpkm or die "$!";
my @aa;
while(<RPKM>){
    chomp;
    my ($gene,$rp)=(split)[0,3];
    push (@aa,$rp);
}

my $for_r=join(',',@aa);
open OUT,"+>quantile.R" or die "$!";
print OUT "cc<-c($for_r)\nquantile(cc,probs=seq(0,1,0.2))";
my $quantile=`R --vanilla --slave <quantile.R`;
my ($fir,$sec,$thir,$four,$five)=(split(/\s+/,$quantile))[-5,-4,-3,-2,-1];

open RPKM,$rpkm or die "$!";
while(<RPKM>){
    chomp;
    my ($gene,$rp)=(split)[0,3];
    if($rp<=$fir){
        print "$gene{$gene}\t$rp\t1\n";
    }elsif($rp>=$fir && $rp<=$sec){
        print "$gene{$gene}\t$rp\t2\n";
    }elsif($rp>$sec && $rp<=$thir){
        print "$gene{$gene}\t$rp\t3\n";
    }elsif($rp>$thir && $rp<=$four){
        print "$gene{$gene}\t$rp\t4\n";
    }elsif($rp>$four && $rp<=$five){
        print "$gene{$gene}\t$rp\t5\n";
    }else{

    }
}

sub usage{
    my $die=<<DIE;
    perl *.pl <RPKM> <Genepos_workingset with categories>
    Rank to five groups based on gene expression level.
DIE
}
