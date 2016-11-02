#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==1;
my ($vcf) = @ARGV;
open VCF,$vcf or die "$!";
my $header = <VCF>;
   chomp $header;
my ($hchr,$hpos,$dot,@inbred) = split(/\t/,$header);
my %hash_stat;
while(<VCF>){
    chomp;
    my ($chr,$pos,$ref,@geno) = split;
    for(my $i = 0 ; $i < @geno; ++$i){
        next if $geno[$i] eq "x";
        if($geno[$i] ne $ref){
            $hash_stat{$inbred[$i]} ++;
        }
    }
}

foreach(keys %hash_stat){
    print "$_\t$hash_stat{$_}\n";
}

sub usage{
    my $die =<<DIE;
    perl *.pl <vcf> 
DIE
}
