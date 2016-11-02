#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 7;
my ($chisq,$imp2to1_mat,$imp2to1_pat,$imp5to1_mat,$imp5to1_pat,$g_smRNA_b73,$g_smRNA_mo17) = @ARGV;
open CHI,$chisq or die "$!";
open CRI1,"+>$imp2to1_mat" or die "$!";
open CRI2,"+>$imp2to1_pat" or die "$!";
open CRI3,"+>$imp5to1_mat" or die "$!";
open CRI4,"+>$imp5to1_pat" or die "$!";
open CRI5,"+>$g_smRNA_b73" or die "$!";
open CRI6,"+>$g_smRNA_mo17" or die "$!";

while(<CHI>){
    chomp;
    my ($gene,$stt,$end,$snp_nu,$bm_b,$bm_m,$mb_b,$mb_m,$pvalue1,$pvalue2) = split;
    next if ($snp_nu < 2 || $bm_b + $bm_m < 10 || $mb_b + $mb_m < 10);
    next if ($pvalue1 >= 0.05 || $pvalue2 >= 0.05);
    print CRI1 "$_\n" if ($bm_b/($bm_b+$bm_m) > 2/3 && $mb_m/($mb_b+$mb_m)> 2/3);
    print CRI2 "$_\n" if ($bm_m/($bm_b+$bm_m) > 1/3 && $mb_b/($mb_b+$mb_m)> 1/3);
    print CRI3 "$_\n" if ($bm_b/($bm_b+$bm_m) > 10/11 && $mb_m/($mb_b+$mb_m) > 10/11);
    print CRI4 "$_\n" if ($bm_m/($bm_b+$bm_m) > 5/7 && $mb_b/($mb_b+$mb_m) > 5/7);
    print CRI5 "$_\n" if ($bm_b/($bm_b+$bm_m) > 10/11 && $mb_b/($mb_b+$mb_m) > 5/7);
    print CRI6 "$_\n" if ($bm_m/($bm_b+$bm_m) > 5/7 && $mb_m/($mb_b+$mb_m) > 10/11);
}
sub usage{
    my $die=<<DIE;
    perl *.pl <Chi sq results> <2 to 1 MEG> <2 to 1 PEG> <5 to 1 MEG> <5 to 1 PEG> <5 to 1 g_smRNA_b73> <5 to 1 g_smRNA_mo17>
DIE
}
