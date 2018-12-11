#!/usr/bin/perl -w
use strict;
my $seq;
my @aa=<>;
chomp @aa;
my $all=join '',@aa;
@aa=split(/>/,$all);
chomp @aa;
my ($chr7)=grep(/^chr7/,@aa);
$chr7=~s/chr7//;

my $gene=substr($chr7,114784966,2000);

print "$gene\n";



