#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==3;
my ($bm,$mb,$out) = @ARGV;

my ($win_stat1,$win_stat2,$win_lap) = (0,0,0);

open BM,$bm or die "$!";
my %hash_bm;
while(<BM>){
    chomp;
    ++ $win_stat1;
    my ($chr,$stt,$end,$c_cov1,$c_nu1,$t_nu1,$c_cov2,$c_nu2,$t_nu2) =split;
    $hash_bm{"$chr\t$stt\t$end"} = "$c_cov1\t$c_nu1\t$t_nu1\t$c_cov2\t$c_nu2\t$t_nu2";
}
close BM;
open MB,$mb or die "$!";
my %hash_mb;
while(<MB>){
    chomp;
    ++ $win_stat2;
    my ($chr,$stt,$end,$c_cov1,$c_nu1,$t_nu1,$c_cov2,$c_nu2,$t_nu2) =split;
    $hash_mb{"$chr\t$stt\t$end"} = "$c_cov1\t$c_nu1\t$t_nu1\t$c_cov2\t$c_nu2\t$t_nu2";
}
close MB;

open OUT,"+>$out" or die "$!";
foreach(keys %hash_bm){
   next if !exists $hash_mb{$_};
   ++ $win_lap;
   print OUT "$_\t$hash_bm{$_}\t$hash_mb{$_}\n";
}

close OUT;

print <<OUT;
Number of BM_windows: $win_stat1;
Number of MB_windows: $win_stat2;
NUmber of overlapped windows: $win_lap;
OUT

sub usage{
    my $die=<<DIE;

    perl *.pl <windows BM filter> <windows MB filter>  <OUTPUT>

DIE
}
