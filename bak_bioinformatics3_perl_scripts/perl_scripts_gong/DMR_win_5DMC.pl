#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==1;
my ($insect) = @ARGV;
open IN,$insect or die "$!";
my %dm_win;
while(<IN>){
    chomp;
    my ($chr, $stt, $end, $cytosine1, $c1, $t1, $cytosine2, $c2, $t2, $pval, $padj, $chr_tem,$stt_tem,$end_tem) = split;
    next if $stt_tem == -1;
    push @{$dm_win{"$chr\t$stt\t$end"}}, $stt_tem;
}
close IN;

foreach(keys %dm_win){
    my $num = @{$dm_win{$_}};
    my ($chr) = $_ =~ /(chr\d+)/;
    next if $num < 5;
    my ($stt, $end) = (sort {$a<=>$b} @{$dm_win{$_}})[0, -1];
    print "$_\t$chr\_$stt\_$end\n";
}

sub usage{
    my $die =<<DIE;
    perl *.pl <intersectBed> 
DIE
}
