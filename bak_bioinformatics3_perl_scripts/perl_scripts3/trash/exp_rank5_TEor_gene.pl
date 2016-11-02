#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==1;

my ($ge_pos)=@ARGV;
open POS,$ge_pos or die "$!";
my @aa;
while(<POS>){
    chomp;
    my ($chr,$stt,$end,$gene,$strand,$type,$te_or,$rpkm)=split;
    push (@aa,$rpkm);
}
close POS;

my $for_r=join(',',@aa);
open OUT,"+>quantile.R" or die "$!";
print OUT "cc<-c($for_r)\nquantile(cc,probs=seq(0,1,0.2))";
my $quantile=`R --vanilla --slave <quantile.R`;
my ($fir,$sec,$thir,$four,$five)=(split(/\s+/,$quantile))[-5,-4,-3,-2,-1];
print "$fir,$sec,$thir,$four,$five\n";

open POS,$ge_pos or die "$!";
while(<POS>){
    chomp;
    my ($chr,$stt,$end,$gene,$strand,$type,$te_or,$rp)=split;
    if($rp<=$fir){
        print "$_\t1\n";
    }elsif($rp>=$fir && $rp<=$sec){
        print "$_\t2\n";
    }elsif($rp>$sec && $rp<=$thir){
        print "$_\t3\n";
    }elsif($rp>$thir && $rp<=$four){
        print "$_\t4\n";
    }elsif($rp>$four && $rp<=$five){
        print "$_\t5\n";
    }else{

    }
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Genepos_workingset with categories>
    Rank to five groups based on gene expression level.
DIE
}
