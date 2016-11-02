#!/usr/bin/perl -w
use strict;

foreach(@ARGV){
    system  qq(nohup perl ~/zeamxie/perl_scripts/DynamicTrim.pl -illumina $_ >$_.trim.nohup 2>&1 &);
}

print "Done\n";
