#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 1;
my ($tab) = @ARGV;
open TAB,$tab or die "$!";
my $i = 0;
while(<TAB>){
    chomp;
    ++ $i;
    my ($len, $num, $seq) = split;
    printf ">t%010d\_%d\_%d\n%s\n", $i, $len, $num, $seq;
}

sub usage{
    my $die =<<DIE;
    perl *.pl <tab> 
DIE
}
