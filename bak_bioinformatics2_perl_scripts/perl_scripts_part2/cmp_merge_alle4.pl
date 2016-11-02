#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==5;
my ($bm_b,$bm_m,$mb_b,$mb_m,$out) = @ARGV;
my @win = ($bm_b,$bm_m,$mb_b,$mb_m);
my (@win_stat,$win_lap);
my %hash_win;
for(my $i = 0;$i <= 3;++ $i){
    open WIN,$win[$i] or die "$!";
    while (my $alle=<WIN>){
        chomp $alle;
        $win_stat[$i]++;
        my ($chr,$stt,$end,$c_nu,$t_nu,$meth_lev) =split(/\t/,$alle);
        push @{$hash_win{"$chr\t$stt\t$end"}} , "$c_nu\t$t_nu\t$meth_lev\t";
    }
}

open OUT,"+>$out" or die "$!";
foreach(keys %hash_win){
   ++ $win_lap;
   next if @{$hash_win{$_}} != 4;
   print OUT "$_\t${$hash_win{$_}}[0]\t${$hash_win{$_}}[1]\t${$hash_win{$_}}[2]\t${$hash_win{$_}}[3]\n";
}
close OUT;

print <<OUT;
Number of BM_windows: $win_stat[0] \t $win_stat[1];
Number of MB_windows: $win_stat[1] \t $win_stat[3];
NUmber of overlapped windows: $win_lap;
OUT

sub usage{
    my $die=<<DIE;

    perl *.pl <windows BM_B> <windows BM_M> <windows MB_B> <windows MB_M> <OUTPUT>

DIE
}
