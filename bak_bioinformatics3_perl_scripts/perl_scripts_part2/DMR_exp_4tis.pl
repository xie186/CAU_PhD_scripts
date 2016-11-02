#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 12;
my ($pdmr_mat,$pdmr_pat,$gdmr_b73,$gdmr_mo17,$exp_bb,$exp_bm,$exp_mb,$exp_mm,$out_pdmr_mat,$out_pdmr_pat,$out_gdmr_b73,$out_gdmr_mo17) = @ARGV;

my %hash_exp;
open EXPBB,$exp_bb or die "$!";
<EXPBB>;
while(<EXPBB>){
    chomp;
    my ($id,$fpkm) = (split(/\t/))[0,9];
    push @{$hash_exp{$id}} , $fpkm;
} 

open EXPBM,$exp_bm or die "$!";
<EXPBM>;
while(<EXPBM>){
    chomp;
    my ($id,$fpkm) = (split(/\t/))[0,9];
    push @{$hash_exp{$id}} , $fpkm;
}

open EXPMB,$exp_mb or die "$!";
<EXPMB>;
while(<EXPMB>){
    chomp;
    my ($id,$fpkm) = (split(/\t/))[0,9];
    push @{$hash_exp{$id}} , $fpkm;
}

open EXPMM,$exp_mm or die "$!";
<EXPMM>;
while(<EXPMM>){
    chomp;
    my ($id,$fpkm) = (split(/\t/))[0,9];
    push @{$hash_exp{$id}} , $fpkm;
}


open OUTMAT, "+>$out_pdmr_mat" or die "$!";
open OUTPAT, "+>$out_pdmr_pat" or die "$!";
open OUTB, "+>$out_gdmr_b73" or die "$!";
open OUTM, "+>$out_gdmr_mo17" or die "$!";
open MAT,$pdmr_mat or die "$!";
while(<MAT>){
    chomp;
    my ($chr,$stt,$end) = split;
    # BB	BM	MB	MM
    print OUTMAT "$chr\t$stt\t$end\t$hash_exp{\"$chr\_$stt\_$end\"}[0]\t$hash_exp{\"$chr\_$stt\_$end\"}[1]\t$hash_exp{\"$chr\_$stt\_$end\"}[2]\t$hash_exp{\"$chr\_$stt\_$end\"}[3]\n"
}

open PAT,$pdmr_pat or die "$!";
while(<PAT>){
    chomp;
    my ($chr,$stt,$end) = split;
    print OUTPAT "$chr\t$stt\t$end\t$hash_exp{\"$chr\_$stt\_$end\"}[0]\t$hash_exp{\"$chr\_$stt\_$end\"}[1]\t$hash_exp{\"$chr\_$stt\_$end\"}[2]\t$hash_exp{\"$chr\_$stt\_$end\"}[3]\n"
}

open B,$gdmr_b73 or die "$!";
while(<B>){
    chomp;
    my ($chr,$stt,$end) = split;
    print OUTB "$chr\t$stt\t$end\t$hash_exp{\"$chr\_$stt\_$end\"}[0]\t$hash_exp{\"$chr\_$stt\_$end\"}[1]\t$hash_exp{\"$chr\_$stt\_$end\"}[2]\t$hash_exp{\"$chr\_$stt\_$end\"}[3]\n"
}

open M,$gdmr_mo17 or die "$!";
while(<M>){
    chomp;
    my ($chr,$stt,$end) = split;
    print OUTM "$chr\t$stt\t$end\t$hash_exp{\"$chr\_$stt\_$end\"}[0]\t$hash_exp{\"$chr\_$stt\_$end\"}[1]\t$hash_exp{\"$chr\_$stt\_$end\"}[2]\t$hash_exp{\"$chr\_$stt\_$end\"}[3]\n"
}

sub usage{
    print <<DIE;
    perl *.pl <pDMR_mat> <pDMR_pat> <gDMR_b73> <gDMR_mo17> <exp BB> <exp BM> <exp MB> <exp MM> <OUT pDMR mat> <OUT pDMR pat>  <OUT gDMR b73> <OUT gDMR mo17>
DIE
    exit 1;
}
