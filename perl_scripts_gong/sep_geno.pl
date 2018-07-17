#!/usr/bin/perl -w 
use strict;


die usage() unless @ARGV == 1;
my ($geno) = @ARGV;
$/ = "\n>";
open GENO,$geno or die "$!";
while(<GENO>){
    chomp;
    $_ =~ s/>//g;
    my ($chr, $seq) = split(/\n/, $_, 2);
    open TEM, "+>$chr.fasta" or die "$!";
    print TEM ">$chr\n$seq\n";
    close TEM;
}
close GENO;

sub usage{
    my $die =<<DIE;
    perl *.pl <GENO> <> 
DIE
}
