#!/usr/bin/perl -w
use strict;

my ($rep1,$rep2) = @ARGV;

my %hash;
open REP1,$rep1 or die "$!";
while(<REP1>){
    my ($gene) = split;
    $hash{$gene} += 1;
}

open REP2,$rep2 or die "$!";
while(<REP2>){
    my ($gene) = split;
    $hash{$gene} += 2;
}

foreach(keys %hash){
    if($hash{$_} == 1){
        print "$_\ty\tn\n";
    }elsif($hash{$_} == 2){
        print "$_\tn\ty\n";
    }else{
        print "$_\ty\ty\n";
    }
}
