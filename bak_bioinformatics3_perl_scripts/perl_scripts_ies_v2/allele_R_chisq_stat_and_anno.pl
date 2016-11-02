#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 6;
my ($snp_anno, $chisq, $imp2to1_mat, $imp2to1_pat, $imp5to1_mat, $imp5to1_pat) = @ARGV;
open ANNO,$snp_anno or die "$!";
my %snp_anno;
while(<ANNO>){
    chomp;
    my ($chr,$pos,$alleles,$gene,$rela_pos,$ele,$stt,$end,$strand) = split;
    push @{$snp_anno{"$chr\t$pos"}}, "$alleles\t$gene\t$rela_pos\t$ele\t$stt\t$end\t$strand";
}
open CHI,$chisq or die "$!";
open CRI1,"+>$imp2to1_mat" or die "$!";
open CRI2,"+>$imp2to1_pat" or die "$!";
open CRI3,"+>$imp5to1_mat" or die "$!";
open CRI4,"+>$imp5to1_pat" or die "$!";
my $header = "";
while(<CHI>){
    chomp;
    my ($chr,$pos,$bm_b,$bm_m,$mb_b,$mb_m,$strand,$pvalue1,$pvalue2) = split;
    next if ($pvalue1 > 0.05 || $pvalue2 > 0.05);
    my ($imp_2to1,$imp_5to1) = &judge($bm_b,$bm_m,$mb_b,$mb_m);
    foreach my $snp_anno(@{$snp_anno{"$chr\t$pos"}}){
        my ($alleles,$gene,$rela_pos,$ele,$stt,$end,$strand) = split(/\t/,$snp_anno);
        print CRI1 "$_\t$alleles\t$imp_2to1\t$imp_5to1\t$gene\t$rela_pos\t$ele\t$stt\t$end\t$strand\n" if ($bm_b/($bm_b+$bm_m) > 2/3 && $mb_m/($mb_b+$mb_m)>2/3);
        print CRI2 "$_\t$alleles\t$imp_2to1\t$imp_5to1\t$gene\t$rela_pos\t$ele\t$stt\t$end\t$strand\n" if ($bm_m/($bm_b+$bm_m) > 1/3 && $mb_b/($mb_b+$mb_m)>1/3);
        print CRI3 "$_\t$alleles\t$imp_2to1\t$imp_5to1\t$gene\t$rela_pos\t$ele\t$stt\t$end\t$strand\n" if ($bm_b/($bm_b+$bm_m) > 10/11 && $mb_m/($mb_b+$mb_m)>10/11);
        print CRI4 "$_\t$alleles\t$imp_2to1\t$imp_5to1\t$gene\t$rela_pos\t$ele\t$stt\t$end\t$strand\n" if ($bm_m/($bm_b+$bm_m) > 5/7 && $mb_b/($mb_b+$mb_m)>5/7);
    }
}

sub judge{
    my ($bm_b,$bm_m,$mb_b,$mb_m) = @_;
    my ($imp_2to1,$imp_5to1) = (0,0);
    if(($bm_b/($bm_b+$bm_m) > 2/3 && $mb_m/($mb_b+$mb_m)>2/3)){
        $imp_2to1 = "mat";
        if($bm_b/($bm_b+$bm_m) > 10/11 && $mb_m/($mb_b+$mb_m)>10/11){
            $imp_5to1 = "mat";
        }else{
            $imp_5to1 = "NA";
        }
    }elsif($bm_m/($bm_b+$bm_m) > 1/3 && $mb_b/($mb_b+$mb_m)>1/3){
        $imp_2to1 = "pat";
        if(($bm_m/($bm_b+$bm_m) > 5/7 && $mb_b/($mb_b+$mb_m)>5/7)){
            $imp_5to1 = "pat";
        }else{
            $imp_5to1 = "NA";
        }
    }else{
        $imp_2to1 = "NA";
    }
    return ($imp_2to1,$imp_5to1);
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Chi sq results> <2 to 1 MEG> <2 to 1 PEG> <5 to 1 MEG> <5 to 1 PEG>
DIE
}
