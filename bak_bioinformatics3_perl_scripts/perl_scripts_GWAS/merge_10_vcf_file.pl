#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 3;
my ($prefix,$surfix,$nu) = @ARGV;
my @vcf = <$prefix*$surfix>;
open HEAD,$vcf[0] or die "$!";
my $head = <HEAD>;
print "$head";
foreach(@vcf){
    open VCF,$_ or die "$!";
    <VCF>;
    while(<VCF>){
        print "$_";
    }
}
sub usage{
    print <<DIE;
    perl *.pl <prefix> <surfix [.jvcf]> <chrom number>  check the file first
DIE
    exit 1;
}
