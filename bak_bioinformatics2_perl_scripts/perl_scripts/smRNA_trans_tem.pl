#!/usr/bin/perl -w
use strict;
my ($input)=@ARGV;
open IN,$input or die "$!";
while(<IN>){
    chomp;
    if(/^>/ ||!/>/){
        print "$_\n";
    }else{
        my ($seq,$name)=split(/>/,$_);
        print "$seq\n>$name\n";
    }
}
