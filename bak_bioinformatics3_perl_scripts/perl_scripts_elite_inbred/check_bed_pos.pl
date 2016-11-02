#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==2;
my ($geno,$pos) = @ARGV;
open GENO,$geno or die "$!";
my @geno = <GENO>;
shift @geno;
chomp @geno;
my $seq = join("",@geno);
my $base = substr($seq, $pos-2,4);
print "$base\n";


sub usage{
    my $die = <<DIE;
    perl *.pl <genome> <position> 
DIE
}
