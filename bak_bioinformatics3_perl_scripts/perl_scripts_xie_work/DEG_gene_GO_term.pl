#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my ($go_term,$deg_cand) = @ARGV;
open GO, $go_term or die "$!";
my %hash_go;
while(<GO>){
    chomp;
    my ($gene) = split;
    $hash_go{$gene} = $_;
}


open CAND,$deg_cand or die "$!";
while(<CAND>){
    next if /^id/; 
    #id      baseMean        baseMeanA       baseMeanB       foldChange      log2FoldChange  pval    padj
    my ($num,$id,$baseMean,$baseMeanA,$baseMeanB,$foldChange,$log2FoldChange,$pval,$padj) = split;
    #awk '$9 < 0.05 && ($7 > 2 || $7 < -2)'   
    next if $log2FoldChange eq "NA";
    if($padj < 0.05 && abs($log2FoldChange) > 2){
        print "$hash_go{$id}\n";
    }
}  

sub usage{
    my $die =<<DIE;
    perl *.pl <GO term> <DEG candidate> 
DIE
}
