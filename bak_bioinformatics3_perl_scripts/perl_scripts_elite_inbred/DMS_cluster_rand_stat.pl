#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my ($input, $process) = @ARGV;
open IN,$input or die "$!";
my ($all_site,$site_in_cluster) = (0,0);
while(<IN>){
    chomp;
    my ($chr,$stt,$end,$num) = split;
    $all_site += $num;
    $site_in_cluster += $num if $num > 1;
}

my $aver_perc = $site_in_cluster / $all_site;
print "$process\t$aver_perc\n";

sub usage{
    my $die =<<DIE;
    perl *.pl <input> <process>  > output
DIE
}
