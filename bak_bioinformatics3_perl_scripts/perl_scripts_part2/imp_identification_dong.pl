#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 4;
my ($anno1,$anno2,$anno3, $out) = @ARGV;
open ANNO,$anno1 or die "$!";
my %imp_gene1;
my %imp_gene2;
my %imp_gene3;
my %all_gene;
while(<ANNO>){
    chomp;
#    chr3    309281  0       53      0       107      7.37352034196303e-25    2.58592832641162e-13   G/A     NA      NA      GRMZM2G035482   1909    exon    1832    2105    -
    my ($chr,$pos,$bmb,$bmm,$mbb,$mbm,$p1,$p2,$geno,$imp_2to1,$imp_5to1,$gene) = split;
    next if ($gene eq "NA" || $imp_2to1 eq "NA");
    $all_gene{$imp_2to1}->{$gene} -> {"1"} ++;
    
}
close ANNO;

open ANNO,$anno2 or die "$!";
while(<ANNO>){
    chomp;
    my ($chr,$pos,$bmb,$bmm,$mbb,$mbm,$p1,$p2,$geno,$imp_2to1,$imp_5to1,$gene) = split;
    next if ($gene eq "NA" || $imp_2to1 eq "NA");
    $all_gene{$imp_2to1}->{$gene} -> {"2"} ++;
}
close ANNO;

open ANNO,$anno3 or die "$!";
while(<ANNO>){
    chomp;
    my ($chr,$pos,$bmb,$bmm,$mbb,$mbm,$p1,$p2,$geno,$imp_2to1,$imp_5to1,$gene) = split;
    next if ($gene eq "NA" || $imp_2to1 eq "NA");
    $all_gene{$imp_2to1}->{$gene} -> {"3"} ++;    
}
close ANNO;
open OUT, "+>$out" or die "$!";
foreach my $stat(keys %all_gene){
    foreach my $gene(keys %{$all_gene{$stat}}){
        if( keys %{$all_gene{$stat} -> {$gene}} == 3){
            print OUT "$stat\t$gene\n";
        }
    }    
}
close ANNO;
close OUT;

sub usage{
    my $die =<<DIE;
    perl *.pl <anno1> <anno2> <anno3> <OUT>
DIE
}
