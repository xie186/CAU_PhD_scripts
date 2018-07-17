#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 3;
#id      baseMean        baseMeanA       baseMeanB       foldChange      log2FoldChange  pval    padj
#1       AT1G01010       335.738403738441        392.61696915032 278.859838326562        0.710259260902695       -0.493582357390126      0.313206013813159       1
my ($deseq_res, $gene_pos, $cutoff) = @ARGV;

open POS,$gene_pos or die "$!";
my %gene_pos;
while(<POS>){
    chomp;
    my ($chr,$stt,$end,$gene,$strand) = split;
    $gene_pos{$gene} = "$chr\t$stt\t$end\t$gene\t0\t$strand";
}
close POS;

open DES, $deseq_res or die "$!";
while(<DES>){
    chomp;
    next if /log2FoldChange/ || /NA/;
    my ($acc, $id, $baseMean, $baseMeanA, $baseMeanB, $foldChange, $log2FoldChange, $pval, $padj) = split;
    print "$gene_pos{$id}\t$baseMeanA\t$baseMeanB\t$foldChange\t$log2FoldChange\t$pval\t$padj\n" if $padj < $cutoff;
}

sub usage{
    my $die =<<DIE;
    perl *.pl <DESeq results> <gene position> 
DIE
}
