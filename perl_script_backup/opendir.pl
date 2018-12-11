#!/usr/bin/perl -w 
use strict;
my $dir="/home/bioinformatics/mapping_result/Endosperm";

opendir DH,$dir or die;

foreach (readdir DH){
   print "$_\n" if $_=~/^neibor/
}

closedir DH;
