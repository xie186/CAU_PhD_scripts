#!/usr/bin/perl -w
use strict;
my ($pool1,$pool2)=@ARGV;

my %hash;
open POOL1,$pool1 or die "$!";
while(<POOL1>){
    chomp;
    my ($id,$nu) = split(/\s+/,$_);
    my $seq = <POOL1>;
    chomp $seq;
    $hash{$seq} += $nu;
}

open POOL2,$pool2 or die "$!";
while(<POOL2>){
    chomp;
    my ($id,$nu) = split(/\s+/,$_);
    my $seq = <POOL2>;
    chomp $seq;
    $hash{$seq} += $nu;
}

my $uniq_seq = keys %hash;
my $nu=0;
foreach(keys %hash){
    my $len = length $_;
    ++$nu;
    printf ">t%010d\_%d\_%d\n%s\n",$nu,$len,$hash{$_},$_;
}
