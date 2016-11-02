#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 1;
my ($bed) = @ARGV;
open BED,$bed or die "$!";
while(<BED>){
    chomp;
    my ($chr, $stt, $end, $name, $strand) = split;
    my ($up_stt,$up_end) = ($stt - 2000, $stt -1);
    my ($down_stt,$down_end) = ($end + 1, $end + 2000);
    if($strand eq "-"){
        ($up_stt,$up_end) = ($end + 1, $end + 2000);
        ($down_stt,$down_end) = ($stt - 2000, $stt -1);
    }
    $up_stt = 1 if $up_stt < 0;
    $down_stt = 1 if  $down_stt < 0;
    print "$chr\t$up_stt\t$up_end\tUpstream\n";
    print "$chr\t$down_stt\t$down_end\tDownstream\n";
    print "$chr\t$stt\t$end\tGene\n";
}

sub usage{
    my $die = <<DIE;
    perl *.pl <bed>
DIE
}
