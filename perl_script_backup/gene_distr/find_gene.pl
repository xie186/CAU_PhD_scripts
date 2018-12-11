#!/usr/bin/perl -w
use strict;
die "perl *.pl <SNP><IMP_cret5><gene_in_region>\n" unless @ARGV==3;
my %hash;
open SNP,$ARGV[0] or die;
while(<SNP>){
    chomp;
    my @snp=split;
    push(@{$hash{$snp[0]}},$snp[-1]); 
}

open IMP,$ARGV[1] or die;
my %imp;
while(<IMP>){
    chomp;
    my @gene=split;
    $imp{$gene[0]}++;
}

open GENE,$ARGV[2] or die;   # genes between the chromosome region
while(<GENE>){
    chomp;
    my @aa=split;
    next if (exists $imp{$aa[3]});
    if(exists $hash{$aa[3]}){
        print "$_\t@{$hash{$aa[3]}}\n";
    }else{
        print "$_\tNO\n";
    }
}
