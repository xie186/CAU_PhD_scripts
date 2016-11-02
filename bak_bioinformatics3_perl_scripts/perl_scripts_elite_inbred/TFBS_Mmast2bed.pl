#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==1;
my ($mast_out) = @ARGV;

open MAST,$mast_out or die "$!";
while(<MAST>){
    chomp;
    # sequence_name motif hit_start hit_end score hit_p-value
    my ($chr,$motif,$stt,$end,$score,$p_val) = split;
    next if (!/^chr/ || $stt > $end);
    print "$chr\t$stt\t$end\n";
}

sub usage{
    my $die =<<DIE;
    perl *.pl <mast output>
DIE
}
