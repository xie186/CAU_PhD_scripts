#!usr/bin/perl -w
use strict;
die usage() if @ARGV == 0;
open ASM,"sort -k1,1 -k2,2n $ARGV[0] |" or die;
open CLUSTER,$ARGV[1] or die;
my %hash;
while(<ASM>){
   next if /^chromosome/;
   my ($chr,$site) = (split /\s+/,$_)[0,1];
   push @{$hash{$chr}},$site;
}

open STATISTICS,"+>$ARGV[2]" or die;
while(<CLUSTER>){
   my ($chr,$stt,$end) = split;
   if(exists $hash{$chr}){
      my $i;
      print STATISTICS "$chr\t";
      foreach(@{$hash{$chr}}){
         if($_>=$stt && $_<=$end){
            print STATISTICS "$_\t";   
            ++$i;
         } 
      }
      print STATISTICS "$i\n"; 
   }
}

sub usage{
   my $die = <<DIE;
   usage:perl *.pl <ASM> <CLUSTER> <STATISTICS>
DIE
}

