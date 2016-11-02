#!/usr/bin/perl -w
use strict;
my ($synmap)=@ARGV;
die usage() unless @ARGV==1;

open SYN,$synmap or die "$!";
while(<SYN>){
    next if /^#/;
    my ($spec1,$spec2)=(split(/\t/,$_))[1,5];
    my ($chr1,$stt1,$end1,$ge_sb)=(split(/\|\|/,$spec1))[0,1,2,3];
    my ($chr2,$stt2,$end2,$ge_zm)=(split(/\|\|/,$spec2))[0,1,2,3];
    print "$chr1\t$stt1\t$end1\t$ge_sb\t$chr2\t$stt2\t$end2\t$ge_zm\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <SynMap results>
DIE
}
