#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 2;
my ($pool1,$pool2) = @ARGV;
my %hash_pool1; my %hash_pool2;
open POOL1,$pool1 or die "$!";
while(<POOL1>){
    chomp;
    my ($id,$nu) =split(/\s/,$_);
    my $seq  = <POOL1>;
    chomp $seq;
    $hash_pool1{$seq} ++;
}

open POOL2,$pool2 or die "$!";
while(<POOL2>){
    chomp;
    my ($id,$nu) =split(/\s/,$_);
    my $seq  = <POOL2>;
    chomp $seq;
    $hash_pool2{$seq} ++;
}

my $lap = 0;
foreach(keys %hash_pool1){
    ++$lap if exists $hash_pool2{$_}
}
my $pool1_uniq = (keys %hash_pool1) - $lap;
my $pool2_uniq = (keys %hash_pool2) - $lap;
print "$pool1\t$pool2\t$lap\t$pool1_uniq\t$pool2_uniq\n";

sub usage{
    my $die=<<DIE;
    perl *.pl <POOL1> <POOL2>
DIE
}
