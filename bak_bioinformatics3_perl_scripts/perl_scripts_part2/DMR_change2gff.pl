#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 2;
my ($dmr_pos,$biotype) = @ARGV;

open POS,$dmr_pos or die "$!";
while(<POS>){
    chomp;
    my ($chr,$stt,$end) = split;
    print "$chr\tZEAMXIE\tgene\t$stt\t$end\t.\t+\t.\tID=$chr\_$stt\_$end;Name=$chr\_$stt\_$end;biotype=$biotype\n";
}

sub usage{
    print <<DIE;
    perl *.pl <DMR postion> <Biotype [pDMR][gDMR]>
DIE
    exit 1;
}
