#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==1;
my ($geno)=@ARGV;

open GENO,$geno or die "$!";

my @tem=<GENO>;
my $chr=shift @tem;
my $seq=join '',@tem;
   

print "Chrom\tC\tCpG\tCHG\tCHH\n";
my $c  =$seq=~s/C/C/g;
my $cg =$seq=~s/CG/CG/g;
my $cAg=$seq=~s/CAG/CAG/g;
my $cTg=$seq=~s/CTG/CTG/g;
my $cCg=$seq=~s/CCG/CCG/g;
my $chg=$cAg+$cTg+$cCg;

my $chh=($c-$cg-$chg);
print "$chr\t$c\t$cg\t$chg\t$chh\n";
print "$chh\n";

sub usage{
    my $die=<<DIE;
    perl *.pl <GENOME>
DIE
}
