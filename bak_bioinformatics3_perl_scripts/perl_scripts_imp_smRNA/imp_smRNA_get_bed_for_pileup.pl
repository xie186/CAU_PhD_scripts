#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==1;
my ($imp) = @ARGV;
open IMP,$imp or die "$!";
while(<IMP>){
    chomp;
    my ($chr,$stt,$end) = split;
    $stt -= 100;
    $end += 100;
    print "$chr\t$stt\t$end\n";
}

sub usage{
    print <<DIE;
    perl *.pl <imp smRNA cluster> 
DIE
    exit 1;
}
