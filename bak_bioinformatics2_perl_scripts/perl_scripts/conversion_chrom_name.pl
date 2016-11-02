#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==1;
my ($bismark)=@ARGV;
open BIS,$bismark or die "$!";
while(<BIS>){
    $_=~s/chr0/chr/;
    print "$_";
    
}


sub usage{
    my $die=<<DIE;
    perl *.pl <Bismark results>
DIE
}

