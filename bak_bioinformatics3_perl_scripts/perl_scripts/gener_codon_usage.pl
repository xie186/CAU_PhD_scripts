#!/usr/bin/perl -w
use strict;

our %codonrfull = (UUU=>"Phenylalanine", UUC=>"Phenylalanine", UCU=>"Serine", UCC=>"Serine", UAU=>"Tyrosine", UAC=>"Tyrosine", UGU=>"Cysteine", UGC=>"Cysteine", UUA=>"Leucine", UCA=>"Serine", UAA=>"Stop", UGA=>"Stop", UUG=>"Leucine", UCG=>"Serine", UAG=>"Stop", UGG=>"Tryptophan", CUU=>"Leucine", CUC=>"Leucine", CCU=>"Proline", CCC=>"Proline", CAU=>"Histidine", CAC=>"Histidine", CGU=>"Arginine", CGC=>"Arginine", CUA=>"Leucine", CUG=>"Leucine", CCA=>"Proline", CCG=>"Proline", CAA=>"Glutamine", CAG=>"Glutamine", CGA=>"Arginine", CGG=>"Arginine", AUU=>"Isoleucine", AUC=>"Isoleucine", ACU=>"Threonine", ACC=>"Threonine", AAU=>"Asparagine", AAC=>"Asparagine", AGU=>"Serine", AGC=>"Serine", AUA=>"Isoleucine", ACA=>"Threonine", AAA=>"Lysine", AGA=>"Arginine", AUG=>"Methionine", ACG=>"Threonine", AAG=>"Lysine", AGG=>"Arginine", GUU=>"Valine", GUC=>"Valine", GCU=>"Alanine", GCC=>"Alanine", GAU=>"Aspartic acid", GAC=>"Aspartic acid", GGU=>"Glycine", GGC=>"Glycine", GUA=>"Valine", GUG=>"Valine", GCA=>"Alanine", GCG=>"Alanine", GAA=>"Glutamic acid", GAG=>"Glutamic acid", GGA=>"Glycine", GGG=>"Glycine");

foreach(keys %codonrfull){
     my $tem = $_;
     $tem =~ s/U/T/g;
     print "$tem\t$codonrfull{$_}\n";
}
