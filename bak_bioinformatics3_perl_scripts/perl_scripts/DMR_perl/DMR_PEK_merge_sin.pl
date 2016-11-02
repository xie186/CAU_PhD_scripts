#!/usr/bin/perl -w
use strict;
my ($dmr1,$dmr2)=@ARGV;
die usage() unless @ARGV==2;
open DMR1,$dmr1 or die "$!";
my %dmr1;
while(<DMR1>){
    chomp;
    my ($chr,$pos1,$pos2,$reads,$lev)=split;
    next if $reads<5;
    ${$dmr1{"$chr\t$pos1\t$pos2"}}[0]=$reads;
    ${$dmr1{"$chr\t$pos1\t$pos2"}}[1]=$lev;
}

open DMR2,$dmr2 or die "$!";
while(<DMR2>){
    chomp;
    my ($chr,$pos1,$pos2,$reads,$lev)=split;
    next if $reads<5;
    ${$dmr1{"$chr\t$pos1\t$pos2"}}[2]=$reads;
    ${$dmr1{"$chr\t$pos1\t$pos2"}}[3]=$lev;
}

foreach(keys %dmr1){
    print "$_\t${$dmr1{$_}}[0]\t${$dmr1{$_}}[1]\t${$dmr1{$_}}[2]\t${$dmr1{$_}}[3]\n" if (defined ${$dmr1{$_}}[0] && defined ${$dmr1{$_}}[1] && defined ${$dmr1{$_}}[2] && defined ${$dmr1{$_}}[3]);
}

sub usage{
    my $die=<<DIE;
    perl *.pl <DMR1> <DMR2>
    We use this to merge the methylation information of each tissues
DIE
}
