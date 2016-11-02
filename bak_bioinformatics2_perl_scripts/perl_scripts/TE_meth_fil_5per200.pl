#!/usr/bin/perl -w
use strict;

my ($mth)=@ARGV;
open MTH,$mth or die "$!";
while(<MTH>){
    chomp;
    my ($chr,$stt,$end,$strand,$type1,$type2,$nu,$lev)=split;
    print "$_\n" if $nu>5*($end-$stt+1)/200;
}

