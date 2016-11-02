#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==4;
my ($bed1,$bed2,$bed3,$contxt)=@ARGV;
open BED,$bed1 or die "$!";
my ($tot_dep,$tot_mth)=(0,0);
while(<BED>){
    chomp;
    my ($chr,$stt,$end,$depth,$lev)=split;
    next if $depth < 3;
       $tot_dep+=$depth;
       $tot_mth+=$depth*$lev/100;
}
close BED;

open BED,$bed2 or die "$!";
while(<BED>){
    chomp;
    my ($chr,$stt,$end,$depth,$lev)=split;
    next if $depth < 3;
       $tot_dep+=$depth;
       $tot_mth+=$depth*$lev/100;
}
close BED;

open BED,$bed3 or die "$!";
while(<BED>){
    chomp;
    my ($chr,$stt,$end,$depth,$lev)=split;
    next if $depth < 3;
       $tot_dep+=$depth;
       $tot_mth+=$depth*$lev/100;
}
close BED;

my $aver=$tot_mth/$tot_dep;
print "$contxt\t$aver\n";

sub usage{
    my $die=<<DIE;
    perl *.pl <Bed file> <context>
DIE
}


