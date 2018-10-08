#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==2;
my ($pwd,$out) = @ARGV;
my @file = <$pwd/GAPIT.*.photype.GWAS.ps.p2log>;

open OUT,"+>$out" or die "$!";
foreach my $file(@file){
    chomp $file;
    my ($phe) = $file =~/GAPIT.(.*).photype.GWAS.ps.p2log/;
    print OUT "####$phe\n";
    open LOG,$file or die "$!";
    while(my $snp = <LOG>){
        chomp $snp;
        my ($chr,$pos,$maf,$log) = split(/\t/,$snp);
        print OUT "$snp\n" if $log >=6;
    }
}
close OUT;

sub usage{
    my $die =<<DIE;
    perl *.pl <PWD> <output>
DIE
}
