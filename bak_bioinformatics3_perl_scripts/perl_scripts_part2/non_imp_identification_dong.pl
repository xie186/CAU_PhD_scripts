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
    next if $gene eq "NA";
    $all_gene{$gene} -> {"1"} ++;
    if($p1 < 0.05 && $p2 < 0.05 ){
        if($bmb>$bmm && $mbm>$mbb) {
          $imp_gene1{$gene} ++;
        }
        elsif($bmb<$bmm && $mbm<$mbb) {
          $imp_gene1{$gene} ++;
        }
    }
    
}
close ANNO;

open ANNO,$anno2 or die "$!";
while(<ANNO>){
    chomp;
    my ($chr,$pos,$bmb,$bmm,$mbb,$mbm,$p1,$p2,$geno,$imp_2to1,$imp_5to1,$gene) = split;
    next if $gene eq "NA";
    $all_gene{$gene} -> {"2"} ++;
    if($p1 < 0.05 && $p2 < 0.05){
        if($bmb>$bmm && $mbm>$mbb) {
          $imp_gene2{$gene} ++;
        }
        elsif($bmb<$bmm && $mbm<$mbb) {
          $imp_gene2{$gene} ++;
        }
    }
}
close ANNO;

open ANNO,$anno3 or die "$!";
while(<ANNO>){
    chomp;
    my ($chr,$pos,$bmb,$bmm,$mbb,$mbm,$p1,$p2,$geno,$imp_2to1,$imp_5to1,$gene) = split;
    next if $gene eq "NA";
    $all_gene{$gene} -> {"3"} ++;
    if($p1 < 0.05 && $p2 < 0.05){
        if($bmb>$bmm && $mbm>$mbb) {
          $imp_gene3{$gene} ++;
        }
        elsif($bmb<$bmm && $mbm<$mbb) {
          $imp_gene3{$gene} ++;
        }
    }
}
close ANNO;
open OUT, "+>$out" or die "$!";
foreach my $gene(keys %all_gene){
    my $stage = keys %{$all_gene{$gene}};
    if($stage < 3){
        print "$gene\t$stage\n";
    }
    next if $stage != 3;
    if(! exists $imp_gene1{$gene} && !exists $imp_gene2{$gene} && !exists $imp_gene3{$gene}){
        print OUT "$gene\n";
    }
}
close OUT;

sub usage{
    my $die =<<DIE;
    perl *.pl <anno1> <anno2> <anno3> <OUT>
DIE
}
