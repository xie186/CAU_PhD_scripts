#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 3;
my ($target_gene, $gene, $column) = @ARGV;
open GENE,$gene or die "$!";
my %gene_bed;
while(<GENE>){
    chomp;
    my @tem = split(/\t/, $_);
    $gene_bed{$tem[$column -1]} =$_;
}

open TAR,$target_gene or die "$!";
while(<TAR>){
    chomp;
    my ($chr,$stt,$end, $gene) = split;
    print "$gene_bed{$gene}\n";
}

sub usage{
    my $die =<<DIE;
    perl *.pl <target genes> <all genes> <column> 
DIE
}
