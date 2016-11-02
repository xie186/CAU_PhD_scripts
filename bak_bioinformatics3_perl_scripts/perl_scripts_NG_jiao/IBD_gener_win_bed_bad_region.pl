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
        my ($stt, $end, $alle1, $alle2) = (split(/\t/, $line))[0,-3,-2,-1];
        if($alle1/($alle1 + $alle2) > 0.01 && $alle1/($alle1 + $alle2) < 0.99){
            print "$chr\t$stt\t$end\t$alle1\t$alle2\n";
            $stt = $stt - 1000000 - 1;
            $stt = 0 if $stt < 0;
            $end = $end + 1000000 - 1;
            print "$chr\t$stt\t$end\t$alle1\t$alle2\n";
        }
        
    }
    
}
sub usage{
    my $die =<<DIE;
    perl *.pl <win_file> 
DIE
}
