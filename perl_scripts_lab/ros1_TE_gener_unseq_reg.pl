#!/usr/bin/perl -w
use strict;

my ($unseq) = @ARGV;
open UN, $unseq or die "$!";
while(<UN>){
    chomp;
    my ($eco, $chr, $stt, $end) = split;
    print "$chr\t$stt\t$end\t$eco\n"; 
}

close UN;

