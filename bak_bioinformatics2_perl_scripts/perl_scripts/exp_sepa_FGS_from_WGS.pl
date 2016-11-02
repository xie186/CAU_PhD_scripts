#!/usr/bin/perl -w
use strict;
my ($cpg_oe,$fgs,$rpkm,$tis)=@ARGV;
die usage() unless @ARGV==4;

open CGOE,$cpg_oe or die "$!";
my %hash_oe;
while(<CGOE>){
    chomp;
    my ($gene,$cpg_oe_value)=(split)[3,11];
    $hash_oe{$gene}=$cpg_oe_value;
}

open RPKM,$rpkm or die "$!";
my %hash_fpkm;
while(<RPKM>){
    next if /^gene_short_name/;
    chomp;
    my ($gene,@fpkm)=split;
    my $i=0;
    $i=0 if $tis eq "sd";
    $i=1 if $tis eq "em";
    $i=2 if $tis eq "bm";
    $i=3 if $tis eq "mb"; 
    $hash_fpkm{$gene}=$fpkm[$i];
   # print "$gene\t-\t-\t$fpkm[$i]\n" if (exists $hash{$gene} && $fpkm[$i]>0);
}

open FGS,$fgs or die "$!";
my %hash;
while(<FGS>){
    chomp;
    next if (/^Mt/ || /^Pt/ || /^UNKNOWN/);
    my ($chr,$stt,$end,$gene)=split;
    my $fpkm=$hash_fpkm{$gene};
       $fpkm=0 if !exists $hash_fpkm{$gene};
    print "$gene\t-\t-\t$fpkm\t$hash_oe{$gene}\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <CpG O/E> <Filter gene set (Protein-coding)> <rpkm> <Tissue [sd em bm mb]>
DIE
}
