#!/usr/bin/perl -w
use strict;

open FA,$ARGV[0] or die;
my $i;
my $tot=0;
while(<FA>){
   my $seq=<FA>;
   chomp $_;
   my ($stt,$end)=(split(/_/,$_))[2,3];
#   print "$stt\t$end\n";
   
   my $len=$end-$stt+1;
   $tot=$tot+$len;
   print "$tot\n";
   $i++; 
}

my $average=$tot/$i;
printf "%.2f\n",$average;
