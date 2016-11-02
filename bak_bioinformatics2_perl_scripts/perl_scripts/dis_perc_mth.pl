#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==3;
my ($forw,$rev,$out)=@ARGV;
die "$out exists!!!" if -e $out;
open FORW,$forw or die "$!";
my %methy;my $nu;
while(<FORW>){
    chomp;
    my ($chr,$pos1,$pos2,$depth,$level)=split;
    next if $depth<6;
    my $keys=int $level/10;
    $methy{$keys}++;
    $nu++;
}

open REV,$rev or die "$!";
while(<REV>){
    chomp;
    my ($chr,$pos1,$pos2,$depth,$level)=split;
    next if $depth<6;
    my $keys=int $level/10;
    $methy{$keys}++;
    $nu++;
}

open OUT,"+>$out" or die "$!";
foreach(sort{$a<=>$b} keys %methy){
    my $fraction=$methy{$_}/$nu;
    print OUT "$_\t$fraction\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Forward> <Reverse> <OUT>
    <percentage> <Fraction>
DIE
}
