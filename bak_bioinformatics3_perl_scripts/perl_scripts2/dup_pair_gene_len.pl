#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==2;

my ($pair,$ge_pos)=@ARGV;
open POS,$ge_pos or die "$!";
my %hash_pos;
while(<POS>){
    chomp;
    my ($chr,$stt,$end,$gene,$strand)=split;
    $hash_pos{$gene}="$chr\t$stt\t$end";
}

open PAIR,$pair or die "$!";
while(<PAIR>){
    chomp;
    my ($gene1,$gene2)=(split)[0,2];
    print "$_\t$hash_pos{$gene1}\t$hash_pos{$gene2}\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <duplicate gene pairs> <Gene position>
    Get CpG oe value of duplicate gene pairs
DIE
}
