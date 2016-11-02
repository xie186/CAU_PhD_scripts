#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 3;
my ($region, $meth, $win_size) = @ARGV;

open REG,$region or die "$!";
my %geno_pos;
while(<REG>){
    chomp;
    my ($chr,$stt,$end) = split;
    for(my $i = $stt - $win_size; $i <= $end + $win_size; ++$i ){
        $geno_pos{"$chr\t$i"} ++;
    } 
}
close REG;

$meth = "zcat $meth|" if $meth =~ /gz$/;
open METH,$meth or die "$!";
while(<METH>){
    chomp;
    next if (/chromosome/ || /^chr0/ || /^chr11/ || /^chr12/);
    my ($chr, $stt, $end, $meth_lev) = split;
    next if !exists $geno_pos{"$chr\t$stt"};
    print "$chr\t$stt\t$end\t$meth_lev\n";
}
close METH;

sub usage{
    my $die =<<DIE;
    perl *.pl <region> <meth> <win_size> 
DIE
}
