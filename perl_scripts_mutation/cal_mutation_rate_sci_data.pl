#!/usr/bin/perl -w 
use strict;

die usage() unless @ARGV ==1;
my ($vcf) = @ARGV;

#CHROM  POS    ID      REF     ALT     QUAL    FILTER  INFO    FORMAT  0426    0887    30119   3029    3049    3059    3069 
my @sample_id = ("0426", "0887", "30119", "3029", "3049", "3059", "3069");
open VCF, $vcf or die "$!";
while(<VCF>){
    chomp;
    next if /^#/;
    my ($chr, $pos, $id, $ref, $alt, $qual, $filter, $infor, $format, @individual) = split;
    my ($geno_idx, $depth_idx) = ("NA", "NA");
    my @format = split(/:/, $format);
    for(my $i = 0; $i < @format; ++$i){
        $geno_idx = $i if $format[$i] eq "GT";
        $depth_idx = $i if $format[$i] eq "DP";
    }
    for(my $i = 0; $i < @individual; ++$i){
        next if $sam eq './.';
        my @sam = split(/:/, $sam);
        if($sam[$depth_idx] >=5 && $sam[$depth_idx] <=200){
            print "$chr\t$pos\t$id\t$ref\t$alt\t$qual\t$filter\t$infor\t$sam[$geno_idx]\t$sam[$depth_idx]\n";
        }
    }
}
sub usage{
    my $die = <<DIE;
    perl *.pl <vcf raw variant> 
DIE
}
