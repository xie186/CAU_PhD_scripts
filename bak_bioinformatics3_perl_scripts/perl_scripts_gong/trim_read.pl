#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 4;
my ($fq, $fir_base, $last_base, $out) = @ARGV;
open OUT, "|gzip >$out" or die "$!";
open FQ,$fq or die "$!";
while(my $id = <FQ>){
    my $seq = <FQ>;
    chomp $seq;
    my $len = length $seq;
    my $tem_seq = substr($seq, $fir_base - 1, $len - $fir_base - $last_base);
    my $third = <FQ>;
    my $qual = <FQ>;
    my $tem_qual = substr($qual, $fir_base - 1, $len - $fir_base - $last_base);
    print OUT "$id";
    print OUT "$tem_seq\n$third";
    print OUT "$tem_qual\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <fq> <first base [15]> <last base [15]> 
DIE
}
