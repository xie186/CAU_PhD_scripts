#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 1;
my ($dms_gene) = @ARGV;
open DMS,$dms_gene or die "$!";
my %gene_DMS;
while(<DMS>){
    chomp;
    my ($chr,$stt,$end,$chr1,$stt1,$end1,$geno1_c,$geno1_t,$geno2_c,$geno2_t,$lev1,$lev2,$diff,$pval,$qval, $stat) = split;
    next if $stt1 == -1;
    if($stat eq "S"){
        ${$gene_DMS{"$chr\t$stt\t$end"}}[1] ++;
    } 
    ${$gene_DMS{"$chr\t$stt\t$end"}}[0] ++;
}

foreach(keys %gene_DMS){
    chomp;
    ${$gene_DMS{$_}}[1] = 0 if !${$gene_DMS{$_}}[1];
    print "$_\t${$gene_DMS{$_}}[0]\t${$gene_DMS{$_}}[1]\n"; 
}

sub usage{
    my $die =<<DIE;
    perl *.pl <DMS_DMR> 
DIE
}
