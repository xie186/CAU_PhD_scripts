#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 3;

my ($name,$ge_pos,$up_down) = @ARGV;
open POS,$ge_pos or die "$!";
my %hash_pos;
while(<POS>){
    next if /^UN/;
    chomp;
    my ($chr,$stt,$end,$gene,$strand) = split;
    $stt -= $up_down;
    $end += $up_down;
    $stt = 0 if $stt <0;
    $hash_pos{$gene} = "chr$chr\t$stt\t$end\t$gene\t$strand";
}
open NA,"cut -f1 $name|sort -u|" or die "$!";
while(<NA>){
    chomp;
    print "$hash_pos{$_}\n" if exists $hash_pos{$_};
}


sub usage{
    my $die=<<DIE;
    perl *.pl <Name> <Gene position> <up_down[10000]......> > OUT gene_position_within_2K
DIE
}
