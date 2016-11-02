#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==2;
my ($deg1,$deg2)=@ARGV;
open DEG1,$deg1 or die "$!";
my %hash1;
while(<DEG1>){
   chomp;
   my ($gene,$fpkm1,$fpkm2,$fc,$p_value,$q_value)=(split)[2,7,8,9,11,12];
   $hash1{$gene}="$fpkm1\t$fpkm2\t$fc\t$p_value\t$q_value";
}

open DEG2,$deg2 or die "$!";
my %hash2;
while(<DEG2>){
    chomp;
    my ($gene,$fpkm1,$fpkm2,$fc,$p_value,$q_value)=(split)[2,7,8,9,11,12];
    $hash2{$gene}="$fpkm1\t$fpkm2\t$fc\t$p_value\t$q_value";
}

foreach(keys %hash1){
    print "$_\t$hash1{$_}\t$hash2{$_}\n" if exists $hash2{$_};
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Differencially expressed genes 1> <Differencially expressed genes 2>
DIE
}
