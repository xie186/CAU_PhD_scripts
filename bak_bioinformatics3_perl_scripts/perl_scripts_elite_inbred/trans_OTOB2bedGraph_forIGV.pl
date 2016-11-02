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

open METH,$meth or die "$!";
while(<METH>){
    chomp;
    next if (/chromosome/ || /^chr0/ || /^chr11/ || /^chr12/);
    my ($chr, $stt, $c_num,$t_num) = split;
    next if !exists $geno_pos{"$chr\t$stt"};
    my $end = $stt + 1;
    my $meth_lev = $c_num/ ($c_num + $t_num);
    print "$chr\t$stt\t$end\t$meth_lev\n";
}
close METH;

sub usage{
    my $die =<<DIE;
    perl *.pl <region> <meth> <win_size> 
DIE
}
