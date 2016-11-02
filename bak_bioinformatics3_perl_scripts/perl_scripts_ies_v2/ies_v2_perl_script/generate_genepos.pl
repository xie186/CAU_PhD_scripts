#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==1;
open GFF,$ARGV[0] or die "$!";
while(<GFF>){
    chomp;
    my ($chr,$ele,$stt,$end,$strand,$name)=(split)[0,2,3,4,6,8];
       ($name)=$name=~/\;Name=(.*)\;/;
    next if $ele!~/gene/;
    print "$chr\t$stt\t$end\t$name\t$strand\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <> <>
DIE
}
