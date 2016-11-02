#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 5;
my ($hap,$res_pwd,$pheno,$ld_decay,$p_cut) = @ARGV;

open HAP,$hap or die "$!";
my %hash_geno;
while(<HAP>){
    chomp;
    my ($rs,$alt,$chr,$pos) = split;
    $hash_geno{"$chr\t$pos"} = $alt;
}

open LD,$ld_decay or die "$!";
my %ld_decay;
while(<LD>){
    chomp;
    #chr10   109950604       0.0008616821    378     8771
    my ($chr,$pos,$coef,$snp_nu,$ld_decay_size) = split;
    $ld_decay{"$chr\t$pos"} = $ld_decay_size;
}

open PHE,$pheno or die "$!";
while(my $tem_pheno = <PHE>){
    chomp $tem_pheno;
    open PEAK,"$res_pwd/GAPIT.$tem_pheno.photype.GWAS.ps.p2log" or die "$!";
    while( my $line = <PEAK>){
        chomp $line;
        my ($chr,$pos,$maf,$p_log) = split(/\t/,$line);
        if ($p_log >= $p_cut){
            my ($stt, $end) = ($pos - $ld_decay{"chr$chr\t$pos"}, $pos + $ld_decay{"chr$chr\t$pos"});
            print "$tem_pheno\t$chr\t$pos\t$hash_geno{\"chr$chr\t$pos\"}\t$maf\t$p_log\t$ld_decay{\"chr$chr\t$pos\"}\t$stt\t$end\n";
        }
    }
}

sub usage{
    my $die = <<DIE;
    perl *.pl <hapmap> <GWAS results pwd> <pheno> <ld_decay_peak_snp> <p value cut>
DIE
}
