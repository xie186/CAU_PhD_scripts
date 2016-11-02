#!/usr/bin/perl -w
use strict;

my ($anno) = @ARGV;
open ANNO,$anno or die "$!";
my %hash_gene;
while(<ANNO>){
    chomp;
    next if (/DOWNSTREAM/ || /UPSTREAM/ || /INTERGENIC/);
    my ($chrom,$pos,$id,$ref,$alt,$qual,$filter,$type,$order,$effect,$amino_acid,$chg_pos,$gene,$trans,$intron_num) = split(/\t/);
    $hash_gene{$gene} ++;
}

foreach(keys %hash_gene){
    print "$_\n";
}
