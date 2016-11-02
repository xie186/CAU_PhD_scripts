#!/usr/bin/perl -w
use strict;
my ($tissues)



my ($genepos,$exp,$tissue1,$tissue2)=@ARGV;
open POS,$pos or die "$!";
my %genepos;
while(<POS>){
    chomp;
    my ($chr,$stt,$end,$gene,$strand)=split;
    @{$genepos{$gene}}=($chr,$stt,$end);
}

open EXP,$exp or die "$!";
while(<EXP>){
    chomp;
    my ($gene)=split;
    next if !exists $genepos{$gene};
    
}
