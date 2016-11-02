#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==1;
my ($vcf) = @ARGV;
open VCF,$vcf or die "$!";
my $header = <VCF>;
chomp $header;
my ($hchr,$hpos,$dot,$zheng58,@inbred) = split(/\t/,$header);
my $inbred = join("\t",@inbred);
print "$hchr\t$hpos\t$inbred\n";
my %hash_stat;
while(<VCF>){
    chomp;
    #CHROM  POS     REF     Zheng58 5003    478     8112
    my ($chr,$pos,$ref,$zheng58_geno,@geno) = split;
    my $geno = join("\t",@geno);
    next if $geno  =~ /x/;
    next if ($geno[0] eq $geno[1] && $geno[0] eq $geno[2]);
    print "$chr\t$pos\t$geno\n";
}

foreach(keys %hash_stat){
    print "$_\t$hash_stat{$_}\n";
}

sub usage{
    my $die =<<DIE;
    perl *.pl <vcf> 
DIE
}
