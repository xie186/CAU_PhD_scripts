#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==2;
my ($bis,$chr)=@ARGV;
open BIS,$bis or die "$!";
my $version=<BIS>;
print "$version";
while(<BIS>){
    chomp;
    my ($read,$strand,$chrom)=split(/\s+/,$_);
    print "$_" if $chrom eq $chr;
}

sub usage{
    my $die=<<DIE;
    Usage:perl *.pl <Bismark> <Chromsome>
DIE
}
