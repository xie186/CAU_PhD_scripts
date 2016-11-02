#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==2;
my ($hDMP,$sites) = @ARGV;
my %hDMP;
open DMP,$hDMP or die "$!";
while(<DMP>){
    chomp;
    my ($chr,$pos,$qvalue) = (split)[0,1,10];
    next if $qvalue < 0.01;
    $hDMP{"$chr\t$pos"} ++;
}

$sites = "zcat $sites |" if $sites =~ /gz$/;
open SITE,$sites or die "$!";
while(<SITE>){
    chomp;
    my ($chr,$pos) = split;
    print "$_\n" if exists $hDMP{"$chr\t$pos"};
}

sub usage{
    my $die =<<DIE;
    perl *.pl <hDMP> <sites> 
DIE
}
