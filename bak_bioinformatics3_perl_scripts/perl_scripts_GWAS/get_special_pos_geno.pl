#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==2;
my ($snp_pos,$hapmap) = @ARGV;
open POS,$snp_pos or die "$!";
my %hash_pos;
while(<POS>){
    chomp;
    my ($chr,$pos,$maf,$p_log) = split;
    $chr = "chr".$chr;
    $hash_pos{"$chr\t$pos"} = $p_log;
}

open HAP,$hapmap or die "$!";
my $head = <HAP>;
print "$head";
while(<HAP>){
    chomp;
    my ($rs,$alleles,$chrom,$pos) = split;
    print "$_\n" if exists $hash_pos{"$chrom\t$pos"};
}

sub usage{
    my $die =<<DIE;
    perl *.pl <SNP pos> <Hapmap>
DIE
}
