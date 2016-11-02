#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 3;
my ($snp_geno,$snp_wgs,$out) = @ARGV;
sub usage{
    my $die =<<DIE;
    perl *.pl <SNP genome> <SNP WGS>
DIE
}
my %snp_wgs;
my %snp_geno;
my %snp_both;
open GENO,$snp_geno or die "$!";
while(<GENO>){
    chomp;
    my ($chr,$pos) = split;
    $snp_geno{"$chr\t$pos"} = $_;
    $snp_both{"$chr\t$pos"} ++;
}

open WGS,$snp_wgs or die "$!";
while(<WGS>){
    chomp;
    my ($chr,$pos) = split;
    next if !/^chr\d+/;
    $snp_wgs{"$chr\t$pos"} = $_;
    $snp_both{"$chr\t$pos"} ++;
}

open OUT, "+>$out" or die "$!";
my ($nu_snp_geno,$nu_snp_wgs,$snp_both) = (0,0,0);
foreach(keys %snp_both){
    if(exists $snp_geno{$_} && !exists $snp_wgs{$_}){
        ++ $nu_snp_geno;
        print OUT "snp_geno\t$snp_geno{$_}\n";
    }elsif(!exists $snp_geno{$_} && exists $snp_wgs{$_}){
        ++ $nu_snp_wgs;
        print OUT "snp_wgs\t$snp_wgs{$_}\n";
    }else{
        ++ $snp_both;
        print OUT "snp_both\t$snp_geno{$_}\t$snp_wgs{$_}\n";
    }
}

print <<STAT;
snp identified from genome: $nu_snp_geno;
snp identified from WGS:    $nu_snp_wgs;
snp identified from both:   $snp_both;
STAT
