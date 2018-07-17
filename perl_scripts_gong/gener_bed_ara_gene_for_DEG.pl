#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my ($deg, $bed) = @ARGV;

my %gene_pos;
open BED,$bed or die "$!";
while(<BED>){
    chomp;
    my ($chr,$stt,$end,$gene,$strand) = split;
    $gene_pos{$gene} = "$_";
}

open DEG,$deg or die "$!";
while(<DEG>){
    chomp;
    my ($gene, $p_val) = split;
    $gene = uc $gene;
    #print "$gene\n" if !exists $gene_pos{$gene};
    print "$gene_pos{$gene}\n" if exists $gene_pos{$gene};
}

sub usage{
    my $die =<<DIE;
    perl *.pl <DEG> <bed> 
DIE
}
