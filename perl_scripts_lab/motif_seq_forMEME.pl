#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my ($geno,$reg) = @ARGV;

$/ = "\n>";
open GENO, $geno or die "$!";
my %rec_geno;
while(<GENO>){
    chomp;
    $_ =~ s/>//;
    my ($chr, $seq) = split(/\n/, $_, 2);
    $seq =~ s/\n//g;
    $rec_geno{$chr} = $seq;
}
close GENO;

$/ = "\n";
open SEQ, $reg or die "$!";
while(<SEQ>){
    chomp;
    my ($chr,$stt,$end,$id) = split;
    my $seq = substr($rec_geno{$chr}, $stt-1, $end-$stt+1);
    print ">$id\n$seq\n";
}
close SEQ;

sub usage{
    my $die =<<DIE;
perl *.pl <geno> <region> 
DIE
}
