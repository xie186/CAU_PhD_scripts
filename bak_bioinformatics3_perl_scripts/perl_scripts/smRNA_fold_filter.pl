#!/usr/bin/perl -w
use strict;
my ($input)=@ARGV;

open IN,$input or die "$!";
while(<IN>){
    chomp;
    my $seq=<IN>;
    my $fold=<IN>;
    my ($mfe)=~/\((.*)\)/;
    print "$_\t$mfe\n";
}
