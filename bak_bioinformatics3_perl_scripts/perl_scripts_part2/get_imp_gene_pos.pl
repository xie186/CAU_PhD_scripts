#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 2;

my ($name,$ge_pos) = @ARGV;
open POS,$ge_pos or die "$!";
my %hash_pos;
while(<POS>){
    next if /^UN/;
    chomp;
    my ($chr,$stt,$end,$gene,$strand) = split;
    $hash_pos{$gene} = "chr$chr\t$stt\t$end\t$gene\t$strand";
}
open NA,$name or die "$!";
while(<NA>){
    chomp;
    print "$hash_pos{$_}\n" if exists $hash_pos{$_};
}


sub usage{
    my $die=<<DIE;
    perl *.pl <Name> <Gene position>
DIE
}
