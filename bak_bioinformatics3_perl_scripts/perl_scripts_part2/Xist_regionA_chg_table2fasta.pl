#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 1;
my ($table) = @ARGV;
open TAB,$table or die "$!";
while(<TAB>){
    chomp;
    my ($id,$seq) = split;
    print ">$id\n$seq\n";
}

sub usage{
    my $die =<<DIE;
    perl *.pl <table> 
DIE
}
