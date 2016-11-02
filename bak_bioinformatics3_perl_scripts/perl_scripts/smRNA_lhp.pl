#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==2;
my ($inv,$out)=@ARGV;
open INV,$inv or die "$!";
my @aa=<INV>;
my $join=join('',@aa);
   $join=~s/^\n//;
   @aa=split(/\n\n/,$join);
open OUT1,"+>$out" or die "$!";
foreach(@aa){
    my @tem=split(/\n/);
    my $jug=shift @tem;
    my ($chr)=$jug=~/(chr\d+)/;
    my ($len1,$len2)=$jug=~/(\d+)\/(\d+)/;
    my ($perc)=$jug=~/\((\s*\d+)%\)/;
    next if ($perc<80 || $len1+$len2<300);
    print OUT1 "$_\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <INV file> <Out>
DIE
}
