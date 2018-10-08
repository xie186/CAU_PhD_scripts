#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==1;
my ($snp) = @ARGV;
open SNP,$snp or die "$!";
my @snp = <SNP>;
for(my $i = 0;$i < @snp-1; ++$i){
    my ($chr1,$nu1,$pos1) = split(/\s+/,$snp[$i]);
    my ($chr2,$nu2,$pos2) = split(/\s+/,$snp[$i+1]);
    my $dis = $pos2 - $pos1 + 1;
    print "$i\t$dis\n";
}

sub usage{
    print <<DIE;
    perl *.pl <SNP pos> 
DIE
    exit 1;
}
