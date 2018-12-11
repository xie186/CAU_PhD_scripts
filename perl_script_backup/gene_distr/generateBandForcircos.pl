#!/usr/bin/perl -w
use strict;

while(<>){
    chomp;
    next unless /^cluster/;
    my ($chr,$stt,$end)=(split(/\s+/,$_))[1,2,3];
    print "band\tzeam$chr\tband1\tband2\t$stt\t$end\n";
}
