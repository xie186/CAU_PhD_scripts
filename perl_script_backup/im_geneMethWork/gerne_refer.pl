#!/usr/bin/perl -w
use strict;

opendir DIR,$ARGV[0] or die;
my @aa=readdir DIR;
close DIR;

foreach(@aa){
    print "$ARGV[0]$_\n" if /.+\.fa/;
}
