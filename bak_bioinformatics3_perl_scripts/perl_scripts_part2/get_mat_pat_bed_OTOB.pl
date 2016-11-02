#!/usr/bin/perl -w
use strict;
my ($alle1,$alle2) = @ARGV;

die usage() unless @ARGV ==2;

my %hash_bed;
open ALLE, $alle1 or die "$!";
while(<ALLE>){
    chomp;
    my ($chr,$pos1,$c_num,$t_num) = split;
    ${$hash_bed{"$chr\t$pos1"}}[0] += $c_num;
    ${$hash_bed{"$chr\t$pos1"}}[1] += $t_num;
}
close ALLE;

open ALLE,$alle2 or die "$!";
while(<ALLE>){
    chomp;
    my ($chr,$pos1,$c_num,$t_num) = split;
    ${$hash_bed{"$chr\t$pos1"}}[0] += $c_num;
    ${$hash_bed{"$chr\t$pos1"}}[1] += $t_num;
}

foreach(keys %hash_bed){
    my ($c_num,$t_num) = @{$hash_bed{$_}};
    print "$_\t$c_num\t$t_num\n";
}

sub usage{
    my $die =<<DIE;
    perl *.pl <alle1> <alle2> 
DIE
}
