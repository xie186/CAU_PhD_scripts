#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==2;
my ($bed,$contxt)=@ARGV;
open BED,$bed or die "$!";
my ($tot_dep,$tot_mth)=(0,0);
while(<BED>){
    chomp;
    my ($chr,$stt,$end,$depth,$lev)=split;
    next if $depth < 3;
       $tot_dep+=$depth;
       $tot_mth+=$depth*$lev/100;
}

my $aver=$tot_mth/$tot_dep;
print "$contxt\t$aver\n";

sub usage{
    my $die=<<DIE;
    perl *.pl <Bed file> <context>
DIE
}


