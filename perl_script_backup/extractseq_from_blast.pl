#!/usr/bin/perl -w
#print <<illustration; To extract the genes\' names who have aligned to the database


use strict;

open BLAST,$ARGV[0] or die;
my %hash;

while(<BLAST>){
    chomp $_;
    my ($name)=(split(/\s+/,$_))[0];
    $hash{$name}++;
}

my @key=keys(%hash);
foreach(@key){
    print "$_\n";
}
