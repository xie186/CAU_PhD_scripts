#!/usr/bin/perl -w
use strict;
die unless @ARGV==3;
my ($chr_masked_einverted_RNAfold,$chr_masked_einverted_RNAfold_single_loop,$chr_masked_einverted_RNAfold_multi_loop)=@ARGV;
open FILE,$chr_masked_einverted_RNAfold or die"$!";
open OUT,"+>$chr_masked_einverted_RNAfold_single_loop" or die"$!";
open RES,"+>$chr_masked_einverted_RNAfold_multi_loop" or die"$!"; 
while(<FILE>) {
  chomp;
  my $smRNA_name=$_;
  my $smRNA_sequence=<FILE>;
  chomp($smRNA_sequence);
      $smRNA_sequence=~tr/a|t|c|g|u/A|T|C|G|U/;
  my $smRNA_RNAfold=<FILE>;
  chomp($smRNA_RNAfold);
  my $n=0;
   my @ss=split/L\.+R/,$smRNA_RNAfold;
    $n=@ss;
    
      if($n==2) {
      $smRNA_RNAfold=~s/R/\)/g;$smRNA_RNAfold=~s/L/\(/g;
      print OUT "$smRNA_name\n$smRNA_sequence\n$smRNA_RNAfold\n";
      }
      elsif($n>2) {
      print RES "$smRNA_name\n$smRNA_sequence\n$smRNA_RNAfold\n";}
  }

 
