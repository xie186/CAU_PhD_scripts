#!/usr/bin/perl -w
use strict;

my ($vcf, $ref, $out) = @ARGV;
open REF, $ref or die "$!";
my %stat_num;
while(<REF>){
    chomp;
    my ($type) = split;
    $stat_num{$type} =0;
}
open VCF, $vcf or die "$!";
while(<VCF>){
    chomp;
    #CHROM  POS     ID      REF     ALT     QUAL    FILTER  INFO    FORMAT  XZ31 
    my ($chr,$pos,$id,$ref,$alt,$qual, $filter, $infor, $format, $sam) = split;
    my ($type) = $infor =~ /MEINFO=(.*),\d+,\d+,.*/;
    my @format = split(/:/, $format);
    my @sam = split(/:/, $sam);
    my %stat_infor;
    for(my $i =0; $i < @format; ++$i){
        $stat_infor{$format[$i]} = $sam[$i];
    }
    #FL=6 & GQ>=28  % FL=7 & GQ>=20  FL=8 & GQ>=20
    if(($stat_infor{"FL"} ==6 && $stat_infor{"GQ"} >= 28) ||
       ($stat_infor{"FL"} ==7 && $stat_infor{"GQ"} >= 20) ||
       ($stat_infor{"FL"} ==8 && $stat_infor{"GQ"} >= 20)){
        print qq($chr\t$pos\t$id\t$ref\t$alt\t$qual\t$type\t$stat_infor{"FL"}\t$stat_infor{"GQ"}\n);
        $stat_num{$type} ++;
    }
}
close VCF;

my @key;
my @stat;
foreach(sort keys %stat_num){
    push @key, $_;
    push @stat, $stat_num{$_}; 
}
open OUT, "+>$out" or die "$!";
my $key = join("\t", @key);
my $stat = join("\t", @stat);
print OUT "$key\n$stat\n";
close OUT;
