#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==4;
my ($sample1,$sample2,$sample3,$sample4) = @ARGV;

my %hash_site;
open SAM1,$sample1 or die "$!";
while(<SAM1>){
    chomp;
    my ($chr,$pos) = split;
    $hash_site{"$chr\t$pos"} ++;
}

open SAM2,$sample2 or die "$!";
while(<SAM2>){
    chomp;
    my ($chr,$pos) = split;
    $hash_site{"$chr\t$pos"} ++;
}

open SAM3,$sample3 or die "$!";
while(<SAM3>){
    chomp;
    my ($chr,$pos) = split;
    $hash_site{"$chr\t$pos"} ++;
}

open SAM4,$sample4 or die "$!";
while(<SAM4>){
    chomp;
    my ($chr,$pos) = split;
    $hash_site{"$chr\t$pos"} ++;
}

foreach(keys %hash_site){
    print "$_\n" if $hash_site{$_} == 4;
}

sub usage{
    print <<DIE;
    perl *.pl <Sample1> <Sample2> <Sample3> <Sample4>
DIE
    exit 1;
}
