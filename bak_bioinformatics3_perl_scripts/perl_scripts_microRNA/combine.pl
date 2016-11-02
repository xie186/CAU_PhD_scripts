#!/usr/bin/perl -w
open F,"$ARGV[0]";
open O,"+>$ARGV[1]";
  while(<F>) {
  chomp;
  $_.=_chr10;
  $seq=<F>;
  print O "$_\n$seq";
}
