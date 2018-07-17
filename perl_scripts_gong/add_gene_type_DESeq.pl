#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my ($cuffdiff, $type) = @ARGV;

my %gene_type;
open TYPE, $type or die "$!";
while(<TYPE>){
    chomp;
    my ($chr,$stt,$end,$id,$strand,$type) = split;
    $gene_type{$id} = $_;
}
open DIFF, $cuffdiff or die "$!";
my $header = <DIFF>;
my ($id, $baseMean, $baseMeanA, $baseMeanB, $foldChange, $log2FoldChange, $pval, $padj) =  split(/\t/, $header);
print "chr\tstt\tend\tid\tstrand\ttype\t$baseMean\t$baseMeanA\t$baseMeanB\t$foldChange\t$log2FoldChange\t$pval\t$padj";
while(<DIFF>){
    chomp;
    my ($index, $id, $baseMean, $baseMeanA, $baseMeanB, $foldChange, $log2FoldChange, $pval, $padj) = split;
    $id =~ s/\.\d//g;
    print "$gene_type{$id}\t$baseMean\t$baseMeanA\t$baseMeanB\t$foldChange\t$log2FoldChange\t$pval\t$padj\n";
}

sub usage{
    my $die =<<DIE;
    perl *.pl <cuffdiff> <type> 
DIE
}
