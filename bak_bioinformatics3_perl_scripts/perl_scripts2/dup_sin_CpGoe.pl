#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==2;

my ($pair,$cpg)=@ARGV;
open OE,$cpg or die "$!";
my %hash_cpg;
while(<OE>){
    chomp;
    my ($gene,$type,$cpg_oe)=(split)[3,5,11];
    $hash_cpg{"$gene\t$type"}=$cpg_oe;
}

open PAIR,$pair or die "$!";
while(<PAIR>){
    chomp;
    my ($gene)=split;
    next if !exists $hash_cpg{"$gene\tprotein_coding"};
    print "$_\t$hash_cpg{\"$gene\tprotein_coding\"}\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Single copy gene> <CpG oe>
    Get CpG oe value of single copy gene
DIE
}
