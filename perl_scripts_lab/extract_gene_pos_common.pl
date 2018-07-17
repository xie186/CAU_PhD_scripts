#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 3;
my ($gene_pos, $target, $index) = @ARGV;
open POS,$gene_pos or die "$!";
my %gene_pos;
while(<POS>){
    chomp;
    #chr1    3631    5899    AT1G01010       +       protein_coding_gene;Name=AT1G01010

    my ($chr, $stt,$end, $gene) = split(/\t/, $_);
    $gene_pos{"$gene"} = $_;
}
close POS;


open GENE,$target or die "$!";
while(<GENE>){
    chomp;
    if (/^\t/ || /^#/){
        print "$_\n";
        next;
    }
    my @tem = split;
    print "$gene_pos{$tem[$index-1]}\n"; 
}
close GENE;

sub usage{
    my $die =<<DIE;
    perl *.pl <gene pos> <target gene> <gene column>
DIE
}

