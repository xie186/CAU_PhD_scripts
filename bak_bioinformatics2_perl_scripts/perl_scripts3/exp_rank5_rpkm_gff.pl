#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==1;

my ($ge_pos)=@ARGV;
open POS,$ge_pos or die "$!";
my @aa;my %rpkm;
while(<POS>){
    chomp;
    my ($chr,$ele,$stt1,$end1,$strand,$name,$rpkm)=(split)[0,2,3,4,6,8,9];
    push (@aa,$rpkm) if !exists $rpkm{$name};
    $rpkm{$name}=$rpkm;
}
close POS;

my $for_r=join(',',@aa);
open OUT,"+>quantile.R" or die "$!";
print OUT "cc<-c($for_r)\nquantile(cc,probs=seq(0,1,0.2))";
my $quantile=`R --vanilla --slave <quantile.R`;
my ($fir,$sec,$thir,$four,$five)=(split(/\s+/,$quantile))[-5,-4,-3,-2,-1];
print "##\t$fir,$sec,$thir,$four,$five\n";

open POS,$ge_pos or die "$!";
while(<POS>){
    chomp;
    my @tem=(split)[0,2,3,4,6,8,9];
    my ($chr,$ele,$stt1,$end1,$strand,$name,$rp)=@tem;
    my $print=join("\t",@tem);
    if($rp<=$fir){
        print "$print\t1\n";
    }elsif($rp>=$fir && $rp<=$sec){
        print "$print\t2\n";
    }elsif($rp>$sec && $rp<=$thir){
        print "$print\t3\n";
    }elsif($rp>$thir && $rp<=$four){
        print "$print\t4\n";
    }elsif($rp>$four && $rp<=$five){
        print "$print\t5\n";
    }else{

    }
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Genepos_workingset with categories>
    Rank to five groups based on gene expression level.
DIE
}
