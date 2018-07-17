#!/usr/bin/perl -w
use strict;

my ($list) = @ARGV;

open LIST, $list or die "$!";
while(<LIST>){
    chomp;
    #SRR1170940
    my ($pre) = substr($_, 0, 6);
    print "wget ftp://ftp-trace.ncbi.nih.gov/sra/sra-instant/reads/ByRun/sra/SRR/$pre/$_/$_.sra\n";
}
