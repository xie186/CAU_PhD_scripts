#!/usr/bin/perl -w
use strict;
open GC,$ARGV[0] or die;
while(<GC>){
    my ($gene,$pos,$gcseq)=(split(/\s+/,$_))[0,1,2];
    print "$gene\_$pos\n$gcseq\n";
}
