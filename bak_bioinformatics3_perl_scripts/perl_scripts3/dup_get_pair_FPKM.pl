#!/usr/bin/perl -w
use strict;
my ($rpkm,$pair)=@ARGV;
die usage() unless @ARGV==2;
open RPKM,$rpkm or die "$!";
my %hash_rpkm;
while(<RPKM>){
    chomp;
    my ($gene,$fpkm)=(split)[0,-1];
    $hash_rpkm{$gene}=$fpkm;
}

open PAIR,$pair or die "$!";
while(<PAIR>){
    chomp;
    my ($gene1,$sub1,$gene2,$sub2)=split;
    my ($fpkm1,$fpkm2)=(0,0);
    $fpkm1=$hash_rpkm{$gene1} if exists $hash_rpkm{$gene1};
    $fpkm2=$hash_rpkm{$gene2} if exists $hash_rpkm{$gene2};
    print "$gene1\t$sub1\t$fpkm1\t$gene2\t$sub2\t$fpkm2\n"
}

sub usage{
    my $die=<<DIE;
    perl *.pl <FPKM value > <duplicate gene pairs> 
DIE
}
