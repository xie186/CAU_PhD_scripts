#!/usr/bin/perl -w
use strict;

my ($gene,$entropy) = @ARGV;
die usage() unless @ARGV ==2;
open ENTRO,$entropy or die "$!";
my %gene_entropy;
while(<ENTRO>){
    chomp;
    my ($gene_id,$entropy) = (split)[0,-1];
    $gene_entropy{$gene_id} = $entropy;
}
open GENE,$gene or die "$!";
while(<GENE>){
    chomp ;
    my ($gene_id) = split;
    print "$gene_id\t$gene_entropy{$gene_id}\n" if exists $gene_entropy{$gene_id};
}

sub usage{
    my $die =<<DIE;
    perl *.pl <gene> <entropy> 
DIE
}
