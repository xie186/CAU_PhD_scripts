#!/usr/bin/perl -w
use strict;
die "perl *.pl <fpkm_sd> <fpkm_em> <sd prefer> <em prefer>\n" unless @ARGV==4;
my ($fpkm_sd,$fpkm_em,$pre_sd,$pre_em) = @ARGV;

my %fpkm;
my %fpkm_sd;
my %fpkm_em;
open SD, $fpkm_sd or die "$!";
<SD>;
while(<SD>){
    chomp;
    my ($gene,$fpkm) = (split)[0,9];
    $fpkm{$gene} ++;
    $fpkm_sd{$gene} = $gene if $fpkm >0;
}

open EM, $fpkm_em or die "$!";
<EM>;
while(<EM>){
    chomp;
    my ($gene,$fpkm) = (split)[0,9];
    $fpkm{$gene} ++;
    $fpkm_em{$gene} = $gene if $fpkm >0;
}

open PRESD, "+>$pre_sd" or die "$!";
open PREEM, "+>$pre_em" or die "$!";
foreach(keys %fpkm){
    if(exists $fpkm_sd{$_} && !exists $fpkm_em{$_}){
        print PRESD "$fpkm_sd{$_}\n";
    }elsif(!exists $fpkm_sd{$_} && exists $fpkm_em{$_}){
        print PREEM "$fpkm_em{$_}\n";
    }
}
