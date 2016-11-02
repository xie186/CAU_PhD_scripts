#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==5;
my ($win3,$win5,$win6,$win7,$out) = @ARGV;

open WIN3,$win3 or die "$!";
my %hash;
while(<WIN3>){
    my ($chr,$stt,$end,$nu,$mc,$non_mc,$lev) = split;
    next if ($end-$end+1)*5/200 > $nu;
    push @{$hash{"$chr\t$stt\t$end"}}, $lev;
}

open WIN5,$win5 or die "$!";
while(<WIN5>){
    my ($chr,$stt,$end,$nu,$mc,$non_mc,$lev) = split;
    next if ($end-$end+1)*5/200 > $nu;
    push @{$hash{"$chr\t$stt\t$end"}}, $lev;
}

open WIN6,$win6 or die "$!";
while(<WIN6>){
    my ($chr,$stt,$end,$nu,$mc,$non_mc,$lev) = split;
    next if ($end-$end+1)*5/200 > $nu;
    push @{$hash{"$chr\t$stt\t$end"}}, $lev;
}

open WIN7,$win7 or die "$!";
while(<WIN7>){
    my ($chr,$stt,$end,$nu,$mc,$non_mc,$lev) = split;
    next if ($end-$end+1)*5/200 > $nu;
    push @{$hash{"$chr\t$stt\t$end"}}, $lev;
}

open OUT,"+>$out" or die "$!";
foreach(keys %hash){
    next if @{$hash{$_}}<=3;
    my $tis4_lev = join ("\t",@{$hash{$_}});
    print OUT "$_\t$tis4_lev\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <win_BSR3_mth_lev> <win_BSR5_mth_lev> <win_BSR6_mth_lev> <win_BSR7_mth_lev> <OUT>
DIE
}
