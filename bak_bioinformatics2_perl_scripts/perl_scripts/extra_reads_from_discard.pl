#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==2;

my ($reads,$length)=@ARGV;
open READS,$reads or die "$!";
while(my $fir=<READS>){
    my $sec=<READS>;
    my $thi=<READS>;
    my $for=<READS>;
    chomp $sec;
    if((length $sec)>$length){
        print $fir;
        print "$sec\n";
        print $thi;
        print $for;
    }
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Discarded reads> <>
DIE
}
