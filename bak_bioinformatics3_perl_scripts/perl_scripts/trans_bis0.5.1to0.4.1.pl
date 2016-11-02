#!/usr/bin/perl -w
use strict;
my @file=@ARGV;
die usage() if @file==0;
print "Bismark version: v0.4.1\n";
foreach(@file){
    open FF,$_ or die "$!";
    while(my $line=<FF>){
        next if $line=~/^Bismark version/;
        my @line=split(/\t/,$line);
        pop @line;
        pop @line if $_=~/pe/;
        my $line=join("\t",@line);
        print "$line\n"; 
    }
}


sub usage{
    my $die=<<DIE;
    perl *.pl <Bismark results INT> 
DIE
}
