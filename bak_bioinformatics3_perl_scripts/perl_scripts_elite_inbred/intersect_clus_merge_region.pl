#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==1;
my ($intersect) = @ARGV;

open INTER,$intersect or die "$!";
while(<INTER>){
    chomp;
    #chr9    147502582       147502954       12      12      chr9    147502542
    my ($chr1,$stt1,$end1,$stab1,$unstab1,$chr2,$stt2,$end2,$stab2,$unstab2) = split;
    my ($stt,$end) = (sort {$a<=>$b} ($stt1,$end1,$stt2,$end2)) [0,-1]; 
    my $len = $end - $stt +1;
    print "$chr1\t$stt\t$end\t$chr1:$stt-$end\t$len\n";
}
sub usage{
    my $die =<<DIE;
    perl *.pl <intersectBed> 
DIE
}
