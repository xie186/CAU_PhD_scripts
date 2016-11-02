#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 1;
my ($intersect) = @ARGV;
open INTER,$intersect or die "$!";
while(<INTER>){
    chomp;
    ##chr10   10140954        10142089        .       -1      -1      0
    my ($chr1,$stt1,$end1,$chr2,$stt2,$end2,$base) = split;
    next if $stt2 == -1;
    my @pos = sort{$a<=>$b} ($stt1,$end1,$stt2,$end2);
#    next if $pos[2] - $pos[1] +1 <= 50;
    print "$chr1\t$pos[1]\t$pos[2]\n";
}

sub usage{
    my $die =<<DIE;
    perl *.pl <intersect res> 
DIE
}
