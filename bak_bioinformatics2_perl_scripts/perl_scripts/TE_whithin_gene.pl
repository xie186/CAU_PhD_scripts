#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==2;
my ($repeats,$rpkm)=@ARGV;
open RE,$repeats or die "$!";
my %repeat;
while(<RE>){
    chomp;
    my ($chr,$stt,$end)=(split)[0,1,2];
    my $pos=int ($end+$stt)/2;
    $repeat{"$chr\t$pos"}=$_;
}

open RPKM,$rpkm or die "$!";
while(<RPKM>){
    chomp;
    my ($chr,$stt,$end)=(split)[1,2,3];
    for(my $i=$stt-2000;$i<=$end+2000;++$i){
       if (exists $repeat{"$chr\t$i"}){
           print "$_\t$repeat{\"$chr\t$i\"}\n";
       }
    }
}

sub usage{
    my $die=<<DIE;
Usage:perl *.pl <Repeats position> <Gene position and RPKM value>
    We use this to get the gene that with a class of repeatss within them.
DIE
}
