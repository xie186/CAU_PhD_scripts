#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==2;
my ($chr_masked_einverted_RNAfold_single_loop,$chr_masked_einverted_RNAfold_single_loop_blast)=@ARGV;
open FILE,$chr_masked_einverted_RNAfold_single_loop or die"$!";
open OUT,"+>$chr_masked_einverted_RNAfold_single_loop_blast" or die"$!";
while(<FILE>) {
  chomp;
  my $smRNA_name=$_;
  my $smRNA_sequence=<FILE>;
  chomp($smRNA_sequence);
   print OUT "$smRNA_name\n$smRNA_sequence\n";
  my $smRNA_RNAfold=<FILE>;
 }
sub usage {
 my $die=<<DIE;
usage: perl script.pl <chr10masked_einverted_RNAfold_single_loop> <chr10masked_einverted_RNAfold_single_loop.fa> 
DIE
}

    
