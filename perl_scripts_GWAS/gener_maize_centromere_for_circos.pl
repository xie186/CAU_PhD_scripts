#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==1;
my ($cent) = @ARGV;
open CENT,$cent or die "$!";
while(<CENT>){
    chomp;
    my ($chr,$stt,$end) = split;
    ($stt,$end) = ($stt*1000000,$end*1000000);
    $chr =~ s/chr//g;
    print "band\tzeam$chr\tband1\tband2\t$stt\t$end\n";
}

sub usage{
    my $die =<<DIE;
    perl *.pl <centromere region> 
DIE
}
