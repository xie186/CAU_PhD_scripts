#!/usr/bin/perl -w
use strict;
my ($map,$p_log) = @ARGV;
open MAP,$map or die "$!";
my %hash_map;
while(<MAP>){
    chomp;
    my ($chr,$rs,$pos) = split;
    $hash_map{"$chr\t$pos"}  = $rs;
}

open LOG,$p_log or die "$!";
while(<LOG>){
    chomp;
    my ($chr,$pos) = split;
    print "$hash_map{\"$chr\t$pos\"}\n";
}
