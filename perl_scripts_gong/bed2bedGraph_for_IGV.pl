#!/usr/bin/perl -w
use strict;

my ($ot,$ob, $cutoff) = @ARGV;
open OT, $ot or die "$!"
while(<OT>){
   chomp;
   my ($chr, $stt, $c_num, $tot, $lev) = split;
   $c_num = int($tot*$lev/100 + 0.5);
   next if $tot < $cutoff;
   print "";
}
close OT;

open OB, $ob or die "$!";
while(<OB>){
    chomp;
    my ($chr, $stt, $c_num, $tot, $lev) = split;
   $c_num = int($tot*$lev/100 + 0.5);
}
