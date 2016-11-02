#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 1;

my ($sam) = @ARGV;
open SAM, $sam or die "$!";
while(<SAM>){
    chomp;
    next if /^\@SQ/;
    #SQ225000001     0       chr1    3611    222     321M    *       0       0   *       AS:i:321       XS:i:47 XF:i:0  XE:i:8  NM:i:0
    my ($id,$flag, $chr,$pos, $qual,$cigar, $chr2,$pos2,$dot1,$dot2, $seq) = split(/\t/);
    my @len = split(/[A-Z\*]/, $cigar);
    #$cigar=~s/[A-Z]/,/g;
    #print "$cigar\t@len\n";
    my $sum = &sum(\@len);
    my ($stt, $end) = ($pos, $pos + $sum);
    print "$chr\t$stt\t$end\t$id\n";
}


sub sum{
    my ($len) = @_;
    my $sum =0;
    foreach(@$len){
       $sum += $_;
    }
    return $sum;
}

sub usage{
    my $die =<<DIE;
    perl *.pl <SAM file>
DIE
}

