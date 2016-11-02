#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my ($sect_res, $win_size) = @ARGV;
open SECT,$sect_res or die "$!";
my %hash_stat;
my %dmr_num;
while(<SECT>){
    chomp;
    my ($chr,$stt,$end,$context,$ele_chr,$ele_stt,$ele_end) = split;
#    my $mid = $end - 2000;
    for(my $i = $ele_stt;$i <= $ele_end; ++$i){
        next if $i < $stt + 4000 - $win_size;
        next if $i > $stt + 4000 + $win_size;;
        $hash_stat{"$context"}++;
    }
    $dmr_num{"$chr\t$stt\t$end"} ++;
}

my $dmr_num = keys %dmr_num;
   $dmr_num = $dmr_num/2;
foreach my $context(keys %hash_stat){
    my $dens = $hash_stat{"$context"} / ($dmr_num * $win_size * 2);
        print "$context\t$dens\n";
}

sub usage{
    my $die =<<DIE;

    perl *.pl <TFBS intersect results> <window size>
    Calculate the TFBS density in the flanking regions per base pair!

DIE
}
