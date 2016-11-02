#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==3;
my ($snp,$out_wgs,$out_nowgs) = @ARGV;

open WGS,"+>$out_wgs" or die "$!";
open NOWGS,"+>$out_nowgs" or die "$!";
open SNP,$snp or die "$!";
my %hash_imp;
my %hash_imp_wgs;
while(<SNP>){
    chomp;
    my ($chr,$pos,$bm_b,$bm_m,$mb_b,$mb_m,$pvalue1,$pvalue2, $alleles,$imp_2to1,$imp_5to1,$gene,$rela_pos,$ele,$stt,$end,$strand) = split;
    print "$chr,$pos,$bm_b,$bm_m,$mb_b,$mb_m,$pvalue1,$pvalue2, $alleles,$imp_2to1,$imp_5to1,$gene,$rela_pos,$ele,$stt,$end,$strand\n";
    $hash_imp{$_} ++;
    if($ele eq "exon" ||$ele eq "intron"){
         $hash_imp_wgs{"$chr\t$pos"} ++;
         print WGS "$_\n";
    }
}

foreach(keys %hash_imp){
    my ($chr,$pos,$bm_b,$bm_m,$mb_b,$mb_m,$pvalue1,$pvalue2, $alleles,$imp_2to1,$imp_5to1,$gene,$rela_pos,$ele,$stt,$end,$strand) = split;
    next if exists $hash_imp_wgs{"$chr\t$pos"};
    print NOWGS "$_\n";
}

sub usage{
    my $die =<<DIE;
    perl *.pl <snp anno> <WGS> <NO WGS> 
DIE
}
