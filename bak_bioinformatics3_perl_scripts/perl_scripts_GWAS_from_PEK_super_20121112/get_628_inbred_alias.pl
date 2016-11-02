#!/usr/bin/perl -w
use strict;
my ($inbred_alias,$alias_cau) = @ARGV;
open ALIAS,$inbred_alias or die "$!";
my %hash;
while(<ALIAS>){
    chomp;
    my ($fam,$alias,$inbred) = split;
    $hash{$alias} = $inbred;
}

open CAU,$alias_cau or die "$!";
while(<CAU>){
    chomp;
    print "$_\t$hash{$_}\n";
}
