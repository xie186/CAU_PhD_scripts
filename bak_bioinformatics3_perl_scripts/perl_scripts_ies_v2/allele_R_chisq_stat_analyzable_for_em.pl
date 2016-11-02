#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 3;
my ($snp_anno, $chisq, $out) = @ARGV;
open ANNO,$snp_anno or die "$!";
my %snp_anno;
while(<ANNO>){
    chomp;
    my ($chr,$pos,$alleles,$gene,$rela_pos,$ele,$stt,$end,$strand) = split;
    push @{$snp_anno{"$chr\t$pos"}}, "$alleles\t$gene\t$rela_pos\t$ele\t$stt\t$end\t$strand";
}
open CHI,$chisq or die "$!";
open OUT,"+>$out" or die "$!";
my $header = "";
while(<CHI>){
    chomp;
    my ($chr,$pos,$bm_b,$bm_m,$mb_b,$mb_m,$pvalue1,$pvalue2) = split;
#    next if ($pvalue1 > 0.05 || $pvalue2 > 0.05);
    my ($imp_2to1,$imp_5to1) = &judge($bm_b,$bm_m,$mb_b,$mb_m);
    foreach my $snp_anno(@{$snp_anno{"$chr\t$pos"}}){
        my ($alleles,$gene,$rela_pos,$ele,$stt,$end,$strand) = split(/\t/,$snp_anno);
        print OUT "$_\t$alleles\t$imp_2to1\t$imp_5to1\t$gene\t$rela_pos\t$ele\t$stt\t$end\t$strand\n";
    }
}

sub judge{
    my ($bm_b,$bm_m,$mb_b,$mb_m) = @_;
    my ($imp_2to1,$imp_5to1) = (0,0);
    if(($bm_b/($bm_b+$bm_m) > 1/2 && $mb_m/($mb_b+$mb_m)> 1/2)){
        $imp_2to1 = "mat";
        if($bm_b/($bm_b+$bm_m) > 5/6 && $mb_m/($mb_b+$mb_m)> 5/6){
            $imp_5to1 = "mat";
        }else{
            $imp_5to1 = "NA";
        }
    }elsif($bm_m/($bm_b+$bm_m) > 1/2 && $mb_b/($mb_b+$mb_m)> 1/2){
        $imp_2to1 = "pat";
        if(($bm_m/($bm_b+$bm_m) > 5/6 && $mb_b/($mb_b+$mb_m)>5/6)){
            $imp_5to1 = "pat";
        }else{
            $imp_5to1 = "NA";
        }
    }else{
        $imp_2to1 = "NA";
        $imp_5to1 = "NA";
    }
    return ($imp_2to1,$imp_5to1);
}

sub usage{
    my $die=<<DIE;
    perl *.pl <snp anno> <Chi sq results> <OUT>
DIE
}
