#!/usr/bin/perl -w
use strict;
my ($rpkm,$sin,$tis)=@ARGV;
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

open SIN,$sin or die "$!";
while(<SIN>){
    chomp;
    my ($gene,$sub)=split;
    my ($fpkm)=(0,0);
    $fpkm=$hash_fpkm{$gene} if exists $hash_fpkm{$gene};
    print "$gene\t$sub\t$fpkm\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <FPKM value of 4 tissues> <Single copy gene> <tissuse name [sd] [em] [bm] [mb]>
DIE
}
