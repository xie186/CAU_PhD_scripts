#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==9;
my ($bm_b, $bm_b_pre,$bm_m, $bm_m_pre, $mb_b, $mb_b_pre, $mb_m, $mb_m_pre, $snp) = @ARGV;
my %hash_bmb;
my %hash_bmm;
my %hash_mbb;
my %hash_mbm;

open BMB,$bm_b or die "$!";
while(<BMB>){
    chomp;
    my ($chr,$pos,$base,$depth)=split;
    $hash_bmb{"$chr\t$pos"} += $depth;
}
close BMB;

open BMB,$bm_b_pre or die "$!";
while(<BMB>){
    chomp;
    my ($chr,$pos,$base,$depth)=split;
    $hash_bmb{"$chr\t$pos"} -= $depth if exists $hash_bmb{"$chr\t$pos"};
}
close BMB;

open BMM,$bm_m or die "$!";
while(<BMM>){
    chomp;
    my ($chr,$pos,$base,$depth)=split;
    $hash_bmm{"$chr\t$pos"} += $depth;
}
close BMM;

open BMM,$bm_m_pre or die "$!";
while(<BMM>){
    chomp;
    my ($chr,$pos,$base,$depth)=split;
    $hash_bmm{"$chr\t$pos"} -= $depth if exists $hash_bmm{"$chr\t$pos"};
}
close BMM;

open MBB,$mb_b or die "$!";
while(<MBB>){
    chomp;
    my ($chr,$pos,$base,$depth)=split;
    $hash_mbb{"$chr\t$pos"} += $depth;
}
close MBB;

open MBB,$mb_b_pre or die "$!";
while(<MBB>){
    chomp;
    my ($chr,$pos,$base,$depth)=split;
    $hash_mbb{"$chr\t$pos"} -= $depth if exists $hash_mbb{"$chr\t$pos"};
}
close MBB;

open MBM,$mb_m or die "$!";
while(<MBM>){
    chomp;
    my ($chr,$pos,$base,$depth)=split;
    $hash_mbm{"$chr\t$pos"} += $depth;
}
close MBM;

open MBM,$mb_m_pre or die "$!";
while(<MBM>){
    chomp;
    my ($chr,$pos,$base,$depth)=split;
    $hash_mbm{"$chr\t$pos"} -= $depth if exists $hash_mbm{"$chr\t$pos"};
}
close MBM;

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
    perl *.pl <BM_b> <BM_b_pre> <BM_m> <BM_m_pre> <MB_b> <MB_b_pre> <MB_m> <MB_m_pre> <snp> 
    We use this scripts to get snp
DIE
}
