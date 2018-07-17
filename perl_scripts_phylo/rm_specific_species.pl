#!/usr/bin/perl -w
use strict;

my ($in, $spec) = @ARGV;
open SPEC, $spec or die "$!";
my %rec_spec;
while(<SPEC>){
    chomp;
    $rec_spec{$_} ++;
}
close SPEC;

open IN, $in or die "$!";
$/ = "\n>";
while(<IN>){
    $_ =~ s/>//g;
    my ($id, $spec) = split(/\s+/, $_);
    if($spec && exists $rec_spec{$spec}){
        next;
    }
    print ">$_";
}
close IN;
