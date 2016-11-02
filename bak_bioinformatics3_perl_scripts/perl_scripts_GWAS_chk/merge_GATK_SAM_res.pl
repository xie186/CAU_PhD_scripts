#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 3;

my ($vcf1,$vcf2,$out_mer) = @ARGV;

open VCF1,$vcf1 or die "$!";
my $head = <VCF1>;
my %snp_pos;
while(<VCF1>){
    chomp;
    my $nu = $_ =~ s/[A-Z]\/[A-Z]/x/g;
    next if $nu > 1; ### delete the hetero-SNPs
    my ($chr,$pos,$alle,@geno) = split;
    $snp_pos{"$chr\t$pos"} ++;
}

open VCF2,$vcf2 or die "$!";
   $head = <VCF2>;
while(<VCF2>){
    chomp;
    my $nu = $_ =~ s/[A-Z]\/[A-Z]/x/g;
    next if $nu > 1; ### delete the hetero-SNPs
    my ($chr,$pos,$alle,@geno) = split;
    $snp_pos{"$chr\t$pos"}  ++;
}

open BOTH,"+>$out_mer" or die "$!";
open VCF,$vcf1 or die "$!";
$head = <VCF>;
print BOTH "$head";
while(<VCF>){
    my ($chr,$pos,$alle,@geno) = split;
    if(exists $snp_pos{"$chr\t$pos"} && $snp_pos{"$chr\t$pos"} ==2){
        print BOTH "$_";
    }
}

sub usage{
    my $die =<<DIE;
    perl *.pl <vcf GATK> <vcf Samtools> <our merge> 
DIE
}
