#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 3;
my ($hapmap, $pheno_list, $res_pwd) = @ARGV;
open HAP,$hapmap or die "$!";
my %hap_snp;
while(<HAP>){
    chomp;
    #snp_chr1_17470001       G/A     chr1    17470001
    my ($rs,$geno,$chr,$pos) = (split)[0,1,2,3];
    $hap_snp{"$chr\t$pos"} = $geno;
}
open PHENO,$pheno_list or die "$!";
while(my $pheno = <PHENO>){
    chomp $pheno;
    open RES,"$res_pwd/GAPIT.$pheno.photype.GWAS.ps.p2log" or die "$!";
#    print "$res_pwd/GAPIT.$pheno.photype.GWAS.ps.p2log\n";
    while(my $line = <RES>){
        my ($chr,$pos,$maf,$p_log) = split(/\t/,$line);
        my $tem_chr = $chr;
           $tem_chr = "chr".$chr;
        if($p_log >= 6){
            print "$pheno\t$chr\t$pos\t$hap_snp{\"$tem_chr\t$pos\"}\t$maf\t$p_log";
        }
    }
}

sub usage{
    my $die =<<DIE;
    perl *.pl <hapmap> <pheno list> <res pwd> 
DIE
}
