#!/usr/bin/perl -w
use strict;
my ($other,$out)=@ARGV;
open OTH,$other or die "$!";
#open UP,"+>$up" or die "$!";
#open DOWN,"+>$down" or die "$!";
open OUT,"+>$out" or die "$!";
my @aa=<OTH>;
my $join=join("",@aa);
   @aa=split(/>/,$join);
shift @aa;
foreach(@aa){
    my ($contig)=(split(/:/,$_))[2];
    my ($pos1,$pos2)=$_=~/Helitron\s*Sequence\s*Location:\s*(\d+),\s*(\d+)/;
    my ($seq)=(split(/Location/,$_))[1];
       ($seq)=(split(/\n/,$seq))[1];
    my $up1=substr($seq,0,20);
    my $down1=substr($seq,(length $seq)-30,30);
#    print UP ">$contig\_$pos1\_$pos2\n$up1\n";
#    print DOWN ">$contig\_$pos1\_$pos2\n$down1\n";
    print OUT ">$contig\_$pos1\_$pos2\n$seq\n";
}
