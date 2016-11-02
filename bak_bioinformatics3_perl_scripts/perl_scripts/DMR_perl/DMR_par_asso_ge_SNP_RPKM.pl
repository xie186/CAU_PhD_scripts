#!/usr/bin/perl -w
use strict;
my ($rpkm,$gene_name,$out)=@ARGV;
die usage() unless @ARGV==3;

open DMR,$gene_name or die "$!";
my %hash;
open OUT,"+>$out" or die "$!";
while(<DMR>){
    chomp;
    my ($gene)=(split)[0];
    $hash{$gene}++;
}

open RPKM,$rpkm or die "$!";
while(<RPKM>){
    chomp;
    my ($gene)=split;
    print OUT "$_\n" if exists $hash{$gene};
}

sub usage{
    my $die=<<DIE;
    perl *.pl <RPKM or gene with SNP> <DMR associated gene name> <OUT>
DIE
}
