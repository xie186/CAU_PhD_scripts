#!/usr/bin/perl -w 
use strict;
die usage() unless @ARGV == 5;
my ($te,$mth_cpg,$mth_chg,$mth_chh, $bin_cut)=@ARGV;

my %hash_cpg;
open CG,$mth_cpg or die "$!";
while(<CG>){
    chomp;
    my ($type,$pos1,$pos2,$lev) = split;
    next if $pos1 !=0;
    $hash_cpg{$type} +=$lev;
}
my %hash_chg;
open CHG,$mth_chg or die "$!";
while(<CHG>){
    chomp;
    my ($type,$pos1,$pos2,$lev) = split;
    next if $pos1 !=0;
    $hash_chg{$type} +=$lev;
}

my %hash_chh;
open CHH,$mth_chh or die "$!";
while(<CHH>){
    chomp;
    my ($type,$pos1,$pos2,$lev) = split;
    next if $pos1 !=0;
    $hash_chh{$type} +=$lev;
}
my %hash;
open TE,$te or die "$!";
while(<TE>){
    chomp;
    my ($chr,$stt,$end,$strand,$type) = split;
    $hash{$type} ++ if $end-$stt+1 >=100;
}

foreach(keys %hash_cpg){
    my $lev_cpg = $hash_cpg{$_}/$bin_cut;
    my $lev_chg = $hash_chg{$_}/$bin_cut;
    my $lev_chh = $hash_chh{$_}/$bin_cut;
    print "$_\t$lev_cpg\t$lev_chg\t$lev_chh\t$hash{$_}\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <TE> <CpG> <CHG> <CHH> <Bin cut>
DIE
}
