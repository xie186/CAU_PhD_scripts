#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 1;
my ($win) = @ARGV;
my @win = split(/,/, $win);
foreach(@win){
    chomp;
    my ($chr) = $_ =~/(chr\d+)/;
    open WIN, $_ or die "$!";
    while( my $line = <WIN>){
        chomp $line;
        my ($stt,$end, $alle1,$alle2) = (split(/\t/, $line))[0,-3,-2,-1];
        print "$chr\t$stt\t$end\t$alle1\t$alle2\n";
    }
    
}
sub usage{
    my $die =<<DIE;
    perl *.pl <win_file> 
DIE
}
