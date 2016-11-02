#!/usr/bin/perl -w
use strict;

die "\n",usage(),"\n" if @ARGV==0;

print "Bismark version: v0.4.1\n";
foreach(@ARGV){
    open BIS,$_ or die "$!";
    while(my $bis=<BIS>){
        next if $bis=~/^Bismark/;
        print "$bis";
    }
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Bismark INT>
    This script help me to merge the results
DIE
}
