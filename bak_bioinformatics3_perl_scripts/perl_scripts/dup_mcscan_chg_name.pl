#!/usr/bin/perl -w
use strict;
my ($input,$out)=@ARGV;
die usage() unless @ARGV==2;
open INPUT,$input or die "$!";
open OUT,"+>$out" or die "$!";
while(<INPUT>){
    chomp;
    my ($gene1,$gene2,$evalue)=split;
    ($gene1)=split(/_/,$gene1) if $gene1=~/^GRM/;
    ($gene2)=split(/_/,$gene2) if $gene2=~/^GRM/;
    print OUT "$gene1\t$gene2\t$evalue\n"
}

sub usage{
    my $die=<<DIE;
    perl *.pl <INPUT blastm8 cut -f1,2,11> <OUTput> 
DIE
}
