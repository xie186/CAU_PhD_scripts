#!/usr/bin/perl -w
use strict;
my ($deg1,$deg2)=@ARGV;
die usage() unless @ARGV==2;
open DEG1,$deg1 or die "$!";
my %hash;
while(<DEG1>){
    chomp;
    my ($gene,$rpkm1,$rpkm2)=split;
    next if $rpkm1>$rpkm2;
    $hash{$gene}=$rpkm1;
}

open DEG2,$deg2 or die "$!";
while(<DEG2>){
    chomp;
    my ($gene,$rpkm1,$rpkm2)=split;
    next if $rpkm1>$rpkm2;
    print "$gene\t$hash{$gene}\t$rpkm1\t$rpkm2\n" if exists $hash{$gene};
}

sub usage{
    my $die=<<DIE;
    perl *.pl <SD2EN> <EM2EN> 
DIE
}
