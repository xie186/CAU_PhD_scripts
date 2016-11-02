#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 3;
my ($win, $cutoff, $flank) = @ARGV;
my @win = split(/,/, $win);
foreach(@win){
    chomp;
    my ($chr) = $_ =~/(chr\d+)/;
    open WIN, $_ or die "$!";
    while( my $line = <WIN>){
        chomp $line;
        my ($stt, $end, $alle1, $alle2) = (split(/\t/, $line))[0,-3,-2,-1];
        if($alle1/($alle1 + $alle2) > 1 - $cutoff && $alle1/($alle1 + $alle2) < $cutoff){
            $stt = $stt - $flank - 1;
            $stt = 0 if $stt < 0;
            $end = $end + $flank;
            print "$chr\t$stt\t$end\t$alle1\t$alle2\n";
        }
    }
    
}

sub usage{
    my $die =<<DIE;
    perl *.pl <win_file> <cutoff> <flank>
DIE
}
