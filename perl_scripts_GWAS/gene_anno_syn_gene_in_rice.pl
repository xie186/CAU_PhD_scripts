#!/usr/bin/perl -w
use strict;

my ($cand_syn,$gene_zm) = @ARGV;
open SYN,$cand_syn or die "$!";
my %hash_syn;
while(<SYN>){
    chomp;
    my ($pheno,$rice,$zm) = split;
    $hash_syn{$zm} = "$pheno\t$rice";
}

open ZM,$gene_zm or die "$!";
while(<ZM>){
     chomp;
     my ($gene) = (split(/\t/,$_))[-1];
     print "$_\t$hash_syn{$gene}\n" if exists $hash_syn{$gene};
}
