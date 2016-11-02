#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 1;
my ($meth) = @ARGV;
open METH,$meth or die "$!";
while(<METH>){
    chomp;
    next if (/chromosome/ || /^chr0/ || /^chr11/ || /^chr12/);
    my ($chr, $stt, $c_num,$t_num) = split;
    my $end = $stt + 1;
    my $meth_lev = $c_num/ ($c_num + $t_num);
    print "$chr\t$stt\t$end\t$meth_lev\n";
}
close METH;

sub usage{
    my $die =<<DIE;
    perl *.pl <meth> <out> 
DIE
}
