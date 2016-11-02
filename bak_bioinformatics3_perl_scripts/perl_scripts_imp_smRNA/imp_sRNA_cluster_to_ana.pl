#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==1;
my ($lap) = @ARGV;
open LAP, $lap or die "$!";
while(<LAP>){
    chomp;
    my ($chr1,$stt1,$end1,$smrna1,$chr2,$stt2,$end2,$smrna2,$lap_nu2,$chr3,$stt3,$end3,$smrna3,$lap_nu3,$chr4,$stt4,$end4,$smrna4,$lap_nu4) = split;
    my @aa = sort {$a<=>$b} ($stt1,$end1,$stt2,$end2,$stt3,$end3,$stt4,$end4);
    print "$chr1\t$aa[0]\t$aa[-1]\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Lap> 
DIE
}
