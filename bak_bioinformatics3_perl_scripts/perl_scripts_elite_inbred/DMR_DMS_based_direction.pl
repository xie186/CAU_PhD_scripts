#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my ($dms_clus, $cutoff)  = @ARGV;
open DMS,$dms_clus or die "$!";
while(<DMS>){
    chomp;
    next if /end/;
    my ($chr,$stt, $end, $lev1, $lev2) = split;
    if($lev1 - $lev2 > $cutoff){
        print "$_\thypo\n";
    }elsif($lev1 - $lev2 < -$cutoff){
        print "$_\thyper\n";
    }
}

sub usage{
    my $die = <<DIE;
    perl *.pl <DMS clus level> <cutoff>  
DIE
}
