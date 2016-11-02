#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==2;
my ($ot,$ob) = @ARGV;
my %hash_stat;
open OT,$ot or die "$!";
while(<OT>){
    chomp;
    ## chr0    20135   20136   1       100
    my ($chr,$stt,$end,$depth) = split;
    next if $depth < 3;
    $hash_stat{"$chr\t$stt"} ++;
}

open OB,$ob or die "$!";
while(<OB>){
    chomp;
    my ($chr,$stt,$end,$depth) = split;
    next if $depth < 3;
    $stt = $stt - 1;
    $hash_stat{"$chr\t$stt"} += 2;
}

foreach(keys %hash_stat){
    print "$_\t$hash_stat{$_}\n";
}

sub usage{
    my $die =<<DIE;
    perl *.pl <OT> <OB>
DIE
}
