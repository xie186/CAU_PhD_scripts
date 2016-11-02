#!/usr/bin/perl -w
use strict;
my ($cpg_oe,$fgs,$prefer)=@ARGV;
die usage() unless @ARGV==3;

open CGOE,$cpg_oe or die "$!";
my %hash_oe;
while(<CGOE>){
    chomp;
    my ($gene,$cpg_oe_value)=(split)[3,11];
    $hash_oe{$gene}=$cpg_oe_value;
}

open PREFER,$prefer or die 
my %hash_pre;
while(<PREFER>){
    chomp;
    my ($gene)=split;
    $hash_pre{$gene}++;
}
open FGS,$fgs or die "$!";
my %hash;
while(<FGS>){
    chomp;
    next if (/^Mt/ || /^Pt/ || /^UNKNOWN/);
    my ($chr,$stt,$end,$gene)=split;
    next if !exists $hash_pre{$gene};
    print "$gene\t-\t-\t$hash_oe{$gene}\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <CpG O/E> <Filter gene set (Protein-coding)> <Gene prefer>  
DIE
}
