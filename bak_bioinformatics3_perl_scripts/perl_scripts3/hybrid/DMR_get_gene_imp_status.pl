#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==6;
my ($rpkm_bm,$tot_snp,$snp,$imp1,$imp2,$ge_pos)=@ARGV;

my %rpkm_bm;
open EXPBM,$rpkm_bm or die "$!";
while(<EXPBM>){
    chomp;
    my ($gene,$rpkm)=(split)[0,-1];
    $rpkm_bm{$gene}=$rpkm;
}

my %tot_snp;
open TOT,$tot_snp or die "$!";
while(<TOT>){
    chomp;
     next if /^##/;
    my ($gene)=split;
    $tot_snp{$gene}++;
}

my %snp;
open SNP,$snp or die "$!";
while(<SNP>){
    chomp;
    my ($gene)=split;
    $snp{$gene}++;
}

my %hash_imp1;
open IMP1,$imp1 or die "$!";
while(<IMP1>){
    chomp;
    my ($gene,$stat)=split;
    $hash_imp1{$gene}=$stat;
}
my %hash_imp2;
open IMP2,$imp2 or die "$!";
while(<IMP2>){
    chomp;
    my ($gene,$stat)=split;
    $hash_imp2{$gene}=$stat;
}

open POS,$ge_pos or die "$!";
while(<POS>){
    chomp;
    my ($chr,$stt,$end,$gene,$strand)=split;
    my $exp=0;
       $exp=$rpkm_bm{$gene} if exists $rpkm_bm{$gene};
    my $tot_snp="NO";
       $tot_snp="YES" if exists $tot_snp{$gene};
    my $snp="NO";
       $snp="YES" if exists $snp{$gene};
    my $imp1="UN";
       $imp1=$hash_imp1{$gene} if exists $hash_imp1{$gene};
    my $imp2="UN";
       $imp2=$hash_imp2{$gene} if exists $hash_imp2{$gene};
   print "$_\t$exp\t$tot_snp\t$snp\t$imp1\t$imp2\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <RPKM> <Total SNP> <SNP> <imp 2to1> <imp 5to1> <gene_position>
DIE
}
