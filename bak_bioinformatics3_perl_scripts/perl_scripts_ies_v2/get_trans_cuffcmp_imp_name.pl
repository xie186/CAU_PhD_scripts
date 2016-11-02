#!/usr/bin/perl -w
use strict;

my ($imp) = @ARGV;
open IMP,$imp or die "$!";
while(<IMP>){
    
}
sub usage{
    print <<DIE;
    perl *.pl <imprinted genes> 
DIE
}
