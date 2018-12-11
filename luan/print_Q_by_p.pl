#!/usr/bin/perl

$a=<STDIN>;
chomp $a;
$q1= -10*log($a)/log(10);

$q2= -10*log($a/(1-$a))/log(10);

print "sanger\t$q1\n";
print "illumina\t$q2\n";
