#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==2;
my ($pileup,$len)=@ARGV;
open PILEUP,$pileup or die "$!";
my %hash;
while(<PILEUP>){
    chomp;
    my ($chr,$pos,$base,$nu)=split;
    $hash{1}++ if $nu>=1;
    $hash{2}++ if $nu>=2;
    $hash{3}++ if $nu>=3;
    $hash{4}++ if $nu>=4;
    $hash{5}++ if $nu>=5;
    $hash{6}++ if $nu>=6;
    $hash{7}++ if $nu>=7;
    $hash{8}++ if $nu>=8;
    $hash{9}++ if $nu>=9;
    $hash{10}++ if $nu>=10;
    $hash{11}++ if $nu>=11;
    $hash{12}++ if $nu>=12;
}

foreach(sort{$a<=>$b} keys %hash){
    my $lev=$hash{$_}/$len;
    print "$_\t$hash{$_}\t$len\t$lev\n";
}

sub usage{
    my $die=<<DIE;
    perl *pl <Pileup> <Chromosome Len>
    
DIE
}
