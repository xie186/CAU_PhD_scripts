#!/usr/bin/perl -w
use strict;
my ($snp,$vcf, $status) = @ARGV;
die usage() unless @ARGV == 3;
open SNP,$snp or die "$!";
my %hash_snp;
while(<SNP>){
    chomp;
    my ($stat,$chr,$pos) = split;
    $hash_snp{"$chr\t$pos"}  ++ if $stat eq $status ;
}

open VCF,$vcf or die "$!";
while(<VCF>){
    next if /^#/;
    chomp;
    #CHROM  POS     ID      REF     ALT     QUAL    FILTER  INFO    FORMAT  cau489 [1/1:0,2:2:6:51,6,0]
    my ($chr,$pos,$id,$ref,$alt,$qual,$filter,$infor,$format,$snp_info) = split;
    my ($geno,$alle1,$alle2,$dep,$GQ,$pl) = $snp_info =~ /(\d\/\d):(\d+),(\d+):(\d+):(.*):\d+,\d+,\d+/;
    if(exists $hash_snp{"$chr\t$pos"}){
        print "$chr\t$pos\t$qual\t$dep\n";
    } 
}

sub usage{
    my $die =<<DIE;
    perl *.pl <SNP pos> <vcf> <status  [good bad]>
DIE
}
