#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==2;
sub usage{
    my $die =<<DIE;
perl *.pl <windowns> <lap> 
DIE
}
my ($win,$lap) = @ARGV;

my %stat_non_identical;
my %stat_identical;
open WIN, $win or die "$!";
while(<WIN>){
    chomp;
    my ($chr, $stt, $end) = split;
    $stat_non_identical{"$chr\t$stt\t$end"} = 0;
    $stat_identical{"$chr\t$stt\t$end"} = 0;
}
close WIN;

open LAP, $lap or die "$!";
while(<LAP>){
    chomp;
    #1       0       200     1       12      35      01344162_23_1   255     -
    my ($chr, $stt, $end, $chr1, $stt1, $end1,$id) = split;
    #01507504_23_7
    my ($smRNA_id, $smRNA, $num) = split(/_/, $id);
    next if $smRNA != 24;
    $stat_non_identical{"$chr\t$stt\t$end"} += $num;
    $stat_identical{"$chr\t$stt\t$end"} ++;
}
close LAP;

foreach(keys %stat_non_identical){
    print "$_\t$stat_non_identical{$_}\t$stat_identical{$_}\n";
}
