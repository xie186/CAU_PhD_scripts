#!/usr/bin/perl -w 
use strict;
die usage() unless @ARGV==2;
my ($fpkm,$cpg_oe)=@ARGV;
open FPKM,$fpkm or die "$!";
my %hash_fpkm;
while(<FPKM>){
    next if /^gene_short_name/;
    chomp;
    my ($gene_id,$sd,$em,$en_bm,$en_mb)=split;
    $hash_fpkm{$gene_id}="$sd\t$em\t$en_bm\t$en_mb";
}

open OE,$cpg_oe or die "$!";
while(<OE>){
    chomp;
    my ($gene)=(split)[3];
    $hash_fpkm{$gene}="0\t0\t0\t0" if !exists $hash_fpkm{$gene};
    print "$_\t$hash_fpkm{$gene}\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <FPKM> <CpG O/E>
DIE
}
