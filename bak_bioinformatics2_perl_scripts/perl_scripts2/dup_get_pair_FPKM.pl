#!/usr/bin/perl -w
use strict;
my ($rpkm,$pair,$tis)=@ARGV;
die usage() unless @ARGV==3;
open RPKM,$rpkm or die "$!";
my %hash_fpkm;
while(<RPKM>){
    next if /^gene_short_name/;
    chomp;
    my ($gene,@fpkm)=split;
    my $i="NA";
    $i=0 if $tis eq "sd";
    $i=1 if $tis eq "em";
    $i=2 if $tis eq "bm";
    $i=3 if $tis eq "mb";
    $hash_fpkm{$gene}=$fpkm[$i];
}

open PAIR,$pair or die "$!";
while(<PAIR>){
    chomp;
    my ($gene1,$sub1,$gene2,$sub2)=split;
    my ($fpkm1,$fpkm2)=(0,0);
    $fpkm1=$hash_fpkm{$gene1} if exists $hash_fpkm{$gene1};
    $fpkm2=$hash_fpkm{$gene2} if exists $hash_fpkm{$gene2};
    print "$gene1\t$sub1\t$fpkm1\t$gene2\t$sub2\t$fpkm2\n"
}

sub usage{
    my $die=<<DIE;
    perl *.pl <FPKM value of 4 tissues> <duplicate gene pairs> <tissuse name [sd] [em] [bm] [mb]>
DIE
}
