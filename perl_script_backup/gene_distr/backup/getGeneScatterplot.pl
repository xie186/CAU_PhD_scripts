#!/usr/bin/perl 
use strict;
my %hash;
open R,$ARGV[0] or die;
while(<R>){
    chomp;
    $hash{$_}=0;
}
close R;

open GE,$ARGV[1] or die;
while(<GE>){
    chomp;
    my @aa=split(/\s+/,$_);
    if(exists $hash{$aa[3]}){
    #    $aa[0]=~s/chr/zeam/;
        print "zeam$aa[0]\t$aa[1]\t$aa[2]\t0.2\n";
    }
}
