#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV ==3;
my ($snp,$win, $step) = @ARGV;
open T, "$snp" or die "$!";
my @snp = <T>;
my $n = @snp;

for(my $i=0; $i < $n; $i += $step){
    last if !$snp[$i + $win + $step] || $snp[$i + $win + $step]=~/^\s+$/;
    my ($chr, $tot_snp_num, $diff_num) = (0, 0, 0);
    my @snp_pos;
    for(my $j=0; $j <= $win-1; $j++){
        my @fen = split(/\s+/,$snp[$i+$j]);
        push @snp_pos, $fen[1];
        $chr = $fen[0];
        my @ff58 = split/\:/,$fen[9];
        my @ff5003 = split/\:/,$fen[10];
        my @ff478 = split/\:/,$fen[11];
        my @ff8112 = split/\:/,$fen[12];
        $tot_snp_num ++;
        if($ff5003[0] ne $ff478[0] && $ff8112[0] ne $ff478[0]){
            $diff_num ++;
        }
     }
     print "$chr\t$snp_pos[0]\t$snp_pos[-1]\t$diff_num\t$tot_snp_num\n";
}

sub usage{
    my $die =<<DIE;
    perl *.pl <snp> <win> <step>
DIE
}
