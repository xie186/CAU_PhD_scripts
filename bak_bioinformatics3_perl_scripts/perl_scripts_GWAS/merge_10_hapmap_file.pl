#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 2;
my ($prefix,$surfix) = @ARGV;
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
    perl *.pl <prefix> <surfix [.hapmap]> <chrom number>  check the file first
DIE
    exit 1;
}
