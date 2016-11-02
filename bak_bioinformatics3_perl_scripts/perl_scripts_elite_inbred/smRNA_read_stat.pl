#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==1;
my ($fasta) = @ARGV;
open FA,$fasta or die "$!";
my ($read_total,$read_len) = (0,0);
my %read_stat;
while(<FA>){
    chomp;
    my $seq = <FA>; 
    my ($id,$len,$num) = (split(/_/,$_))[-3,-2,-1];
    $read_total += $num;
    $read_len += $num*$len;
    $read_stat{$len} += $num;
}

foreach(keys %read_stat){
#    print "$_\t$read_stat{$_}\n";
}

print "$read_total\t$read_len\n";

sub usage{
    my $die =<<DIE;
    perl *.pl <fasta> 
DIE
}
