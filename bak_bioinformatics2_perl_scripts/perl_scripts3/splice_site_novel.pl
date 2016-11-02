#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==4;
my ($trans_sd,$trans_em,$novel_sd,$novel_em) = @ARGV;

open SD,$trans_sd or die "$!";
my %hash;
my %hash_sd;
my %hash_em;
while(<SD>){
    chomp;
    my ($chr,$tools,$exon,$stt,$end) = split;
    $hash{"$chr\t$stt\t$end"} ++;
    $hash_sd{"$chr\t$stt\t$end"} = "$_"
}

open EM,$trans_sd or die "$!";
while(<EM>){
    chomp;
    my ($chr,$tools,$exon,$stt,$end) = split;
    $hash{"$chr\t$stt\t$end"} ++;
    $hash_em{"$chr\t$stt\t$end"} = "$_";
}

open NSD,"+>$novel_sd" or die "$!";
open NEM,"+>$novel_em" or die "$!";
foreach(keys %hash){
    chomp; 
    if (exists $hash_sd{$_}){
        print "$_\n";
        print NSD "$hash_sd{$_}\n";
    }elsif(!exists $hash_sd{$_} && exists $hash_em{$_}){
        print NEM "$hash_em{$_}\n";
    }
    
}

sub usage{
    print <<DIE;
    perl *.pl <Cuff trans sd> <Cuff trans em>  <OUT novel sd> <OUT Novel em>
DIE
    exit 1;
}
