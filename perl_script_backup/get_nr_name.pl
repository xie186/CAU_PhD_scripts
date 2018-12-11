#!/usr/bin/perl -w
use strict;

open NR,$ARGV[0] or die;

while (<NR>){
    my $seq=<NR>;
    print $_;
}
