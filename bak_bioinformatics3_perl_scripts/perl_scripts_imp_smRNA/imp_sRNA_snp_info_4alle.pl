#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==5;
my ($bm_b,$bm_m,$mb_b,$mb_m,$snp) = @ARGV;
my %hash_bmb;
my %hash_bmm;
my %hash_mbb;
my %hash_mbm;
open BMB,$bm_b or die "$!";
while(<BMB>){
    chomp;
    my ($chr,$pos,$base,$depth)=split;
    $hash_bmb{"$chr\t$pos"}=$depth;
}
open BMM,$bm_m or die "$!";
while(<BMM>){
    chomp;
    my ($chr,$pos,$base,$depth)=split;
    $hash_bmm{"$chr\t$pos"}=$depth;
}
open MBB,$mb_b or die "$!";
while(<MBB>){
    chomp;
    my ($chr,$pos,$base,$depth)=split;
    $hash_mbb{"$chr\t$pos"}=$depth;
}
open MBM,$mb_m or die "$!";
while(<MBM>){
    chomp;
    my ($chr,$pos,$base,$depth)=split;
    $hash_mbm{"$chr\t$pos"}=$depth;
}
open SNP,$snp or die "$!";
while(<SNP>){
    chomp;
    my ($chr,$pos)=split;
    $hash_bmb{"$chr\t$pos"}=0 if !exists $hash_bmb{"$chr\t$pos"};
    $hash_bmm{"$chr\t$pos"}=0 if !exists $hash_bmm{"$chr\t$pos"};
    $hash_mbb{"$chr\t$pos"}=0 if !exists $hash_mbb{"$chr\t$pos"};
    $hash_mbm{"$chr\t$pos"}=0 if !exists $hash_mbm{"$chr\t$pos"};
    print "$chr\t$pos\t$hash_bmb{\"$chr\t$pos\"}\t$hash_bmm{\"$chr\t$pos\"}\t$hash_mbb{\"$chr\t$pos\"}\t$hash_mbm{\"$chr\t$pos\"}\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <BM_b> <BM_m> <MB_b> <MB_m> <snp> 
    We use this scripts to get snp
DIE
}
