#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 4;
my ($win, $cutoff, $out1,$out2) = @ARGV;
my @win = split(/,/, $win);
open OUT1, "+>$out1" or die "$!";
open OUT2, "+>$out2" or die "$!";
foreach(@win){
    chomp;
    my ($chr) = $_ =~/(chr\d+)/;
    open WIN, $_ or die "$!";
    while( my $line = <WIN>){
        chomp $line;
        # alle1: 5003      allele2:8112
        my ($stt, $end, $alle1, $alle2) = (split(/\t/, $line))[0,-3,-2,-1];
        if($alle1/($alle1 + $alle2) > $cutoff){
            ### 5003 or 
            print OUT1 "$chr\t$stt\t$end\t$alle1\t$alle2\n";
        }
        if($alle1/($alle1 + $alle2) < 1 - $cutoff){
            ## 8112 or 
            print OUT2 "$chr\t$stt\t$end\t$alle1\t$alle2\n";
        }
    }
    
}
sub usage{
    my $die =<<DIE;
    perl *.pl <win_file> <cutoff>  <out1> <out2>
DIE
}
