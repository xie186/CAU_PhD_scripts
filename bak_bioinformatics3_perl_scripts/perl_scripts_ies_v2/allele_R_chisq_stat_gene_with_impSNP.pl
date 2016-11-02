#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==1;
my ($anno) = @ARGV;
open ANNO,$anno or die "$!";
my %imp_gene;
while(<ANNO>){
    chomp;
#    chr3    309281  0       53      0       107      7.37352034196303e-25    2.58592832641162e-13   G/A     NA      NA      GRMZM2G035482   1909    exon    1832    2105    -
    my ($chr,$pos,$bmb,$bmm,$mbb,$mbm,$p1,$p2,$geno,$imp_2to1,$imp_5to1,$gene) = split;
    if($imp_2to1 =~ /at/){
        $imp_gene{$gene} -> {$imp_2to1} ++;
    }
}

foreach my $gene(keys %imp_gene){
    my @keys = keys %{$imp_gene{$gene}};
    print "$gene\t@keys\n";
}

sub usage{
    my $die =<<DIE;
    perl *.pl <anno> 
DIE
}
