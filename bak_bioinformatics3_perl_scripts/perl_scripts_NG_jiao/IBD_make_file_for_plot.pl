#!/usr/bin/perl -w
use strict;

die "perl *.pl <file1,file2>\n" unless @ARGV == 1;
my ($file) = @ARGV;
my @file = split(/,/,$file);

foreach(@file){
     open FILE,$_ or die "$!";
     my ($chr) = $_ =~ /(chr\d+)/;
     while(my $line = <FILE>){
         print "$chr\t$line";
     }
}


