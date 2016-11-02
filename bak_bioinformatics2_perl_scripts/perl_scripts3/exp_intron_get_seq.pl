#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==4;
my ($blat,$seq,$mul,$sin)=@ARGV;
open BLAT,$blat or die "$!";
my %hash;
while(<BLAT>){
    chomp;
    my @tem=split;
    my ($stt,$end)=(split(/_/,$tem[0]))[2,3];
    if($tem[3]/($end-$stt+1)>=0.8){
        $hash{$tem[0]}++;
    }
}

open OUT1,"+>$mul" or die "$!";
open OUT2,"+>$sin" or die "$!";
open SEQ,$seq or die "$!";
while(<SEQ>){
    chomp;
    my $seq=<SEQ>;
    $_=~s/>//;
    my ($chr,$stt,$end,$name)=$_=~/(chr\d_)\_intron\_(\d+)\_(\d)\_(.*)/;
    if($end-$stt+1<=100){
        print OUT1 "$_\n";
    }
    if($hash{$_}>1){
        print OUT1 "$_\n";        
    }else{
        print OUT2 ">$_\n$seq";
    }
}

sub usage{
    my $die=<<DIE;
    perl *.pl <BLAT> <Intron Sequence> <Intron multi-copy> <Single copy intron> 
DIE
}
