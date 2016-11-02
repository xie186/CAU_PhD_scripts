#!/usr/bin/perl -w
use strict;
my ($rpkm,$name)=@ARGV;
open NAME,$name or die "$!";
my %hash;
while(<NAME>){
    chomp;
    $hash{$_}++;
}

open RPKM,$rpkm or die "$!";
while(<RPKM>){
    chomp;
    my ($gene)=split;
    print "$_\n" if exists $hash{$gene};
}

