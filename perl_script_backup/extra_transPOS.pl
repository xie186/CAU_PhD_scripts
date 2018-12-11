#!/usr/bin/perl -w
use strict;

open FASTA,$ARGV[0] or die;
#open PILUP,$ARGV[1] or die;
my @trans;
while(<FASTA>){ 
   my $seq=<FASTA>; 
   chomp $_;
   my ($chr,$start,$end)=(split(/_/,$_))[1,2,3];
   print "$chr\t$start\t$end\n";
}

#while(<PILUP>){
#    chomp $_;
    
#}
