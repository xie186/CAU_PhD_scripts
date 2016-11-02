#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==2;

my ($pair,$cpg)=@ARGV;
open OE,$cpg or die "$!";
my %hash_cpg;
while(<OE>){
    chomp;
    my ($gene,$cpg_oe)=(split)[3,11];
    $hash_cpg{$gene}=$cpg_oe;
}

open PAIR,$pair or die "$!";
while(<PAIR>){
    chomp;
    my ($gene1,$gene2)=(split)[0,3];
    print "$_\t$hash_cpg{$gene1}\t$hash_cpg{$gene2}\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <duplicate gene pairs> <CpG oe>
    Get CpG oe value of duplicate gene pairs
DIE
}
