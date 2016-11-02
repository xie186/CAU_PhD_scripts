#!/usr/bin/perl -w
use strict;
my ($alle1,$alle2) = @ARGV;

die usage() unless @ARGV ==2;

my %hash_bed;
open ALLE, $alle1 or die "$!";
while(<ALLE>){
    chomp;
    my ($chr,$pos1,$pos2,$tot,$meth_lev) = split;
    my $c_num = int ($meth_lev*$tot/100 + 0.5);
    my $t_num = $tot - $c_num;
    ${$hash_bed{"$chr\t$pos1"}}[0] += $c_num;
    ${$hash_bed{"$chr\t$pos1"}}[1] += $t_num;
}
close ALLE;

open ALLE,$alle2 or die "$!";
while(<ALLE>){
    chomp;
    my ($chr,$pos1,$pos2,$tot,$meth_lev) = split;
    my $c_num = int ($meth_lev*$tot/100 + 0.5);
    my $t_num = $tot - $c_num;
    ${$hash_bed{"$chr\t$pos1"}}[0] += $c_num;
    ${$hash_bed{"$chr\t$pos1"}}[1] += $t_num;
}

foreach(keys %hash_bed){
    my $tot = ${$hash_bed{$_}}[0] + ${$hash_bed{$_}}[1];
    my $lev = ${$hash_bed{$_}}[0]*100 / $tot;
    my ($chr,$pos) = split(/\t/,$_);
    print "$chr\t$pos\t$pos\t$tot\t$lev\n";
}

sub usage{
    my $die =<<DIE;
    perl *.pl <alle1> <alle2> 
DIE
}
