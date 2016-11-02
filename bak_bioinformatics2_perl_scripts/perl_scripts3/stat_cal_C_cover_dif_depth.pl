#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==2;

my ($chr,$bed_ot) = @ARGV;
open CHR,$chr or die "$!";
<CHR>;
my $seq=<CHR>;
chomp $seq;
my $tem1 = $seq=~s/C/C/g;

my ($one,$two,$three,$for,$fiv,$six,$sev,$eigh) = (0,0,0,0,0,0,0,0);
open BED,$bed_ot or die "$!";
while(<BED>){
    chomp;
    my ($chr,$stt,$end,$depth,$lev) = split;    
    ++$one if $depth >=1;
    ++$two if $depth >=2; 
    ++$three if $depth >=3;
    ++$for if $depth >=4;
    ++$fiv if $depth >=5;
    ++$six if $depth >=6;
    ++$sev if $depth >=7;
    ++$eigh if $depth >=8;
}

foreach($one,$two,$three,$for,$fiv,$six,$sev,$eigh){
    print "$_\t$tem1\n";
}
sub usage{
    my $die=<<DIE;
    perl *.pl <Genome sequence [chr10]> <bed file> 
DIE
}
