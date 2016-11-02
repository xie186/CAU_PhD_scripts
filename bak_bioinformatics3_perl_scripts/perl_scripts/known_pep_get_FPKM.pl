#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==2;
my ($prot, $fpkm) = @ARGV;

open FPKM, $fpkm or die "$!";
<FPKM>;
my %gene_fpkm;
while(<FPKM>){
    chomp;
    #-       -       GRMZM2G137366   GRMZM2G137366   -       chr1:2937204-2942164    -       -       6.66968 5.78711 7.55224 OK
    my ($gene,$tem_fpkm) = (split)[0,-2];
    $gene_fpkm{$gene} = $tem_fpkm;
}
open PROT,$prot or die "$!";
while(<PROT>){
    chomp;
    my ($gene,$anno) = split;
    if(exists $gene_fpkm{$gene}){
        print "$_\t$gene_fpkm{$gene}\n";
    }else{
        print "$_\tNA\n";
    }
}

sub usage{
    my $die=<<DIE;
    perl *.pl <prot> <fpkm> 
DIE
}
