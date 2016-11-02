#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my ($sect_res, $win_size) = @ARGV;
open SECT,$sect_res or die "$!";
my %hash_stat;
while(<SECT>){
    chomp;
    my ($chr,$stt,$end,$context,$ele_chr,$ele_stt,$ele_end) = split;
#    my $mid = $end - 2000;
    my $tfbs_base = 0;
    for(my $i = $ele_stt;$i <= $ele_end; ++$i){
        next if $i < $stt + 4000 - $win_size;
        next if $i > $stt + 4000 + $win_size;;
        $tfbs_base ++;
    }
    my $tfbs_dens = $tfbs_base/($win_size * 2);
    print "$context\t$tfbs_dens\n";
}

sub usage{
    my $die =<<DIE;

    perl *.pl <TFBS intersect results> <window size>
    Calculate the TFBS density in the flanking regions per base pair for each DMR!

DIE
}
