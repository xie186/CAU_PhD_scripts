#!/usr/bin/perl -w
use strict;

my ($cufflinks, $gene_list) = @ARGV;
open CUFF, $cufflinks or die "$!";
my %rec_fpkm;
while(<CUFF>){
    chomp;
    my ($track_id, $class_code, $ref_id, $gene_id,$short_name, $tss_id, $locus,$len, $cov, $fpkm) = split;
    $rec_fpkm{$track_id} = $fpkm;
}
close CUFF;

open LIST, $gene_list or die "$!";
while(<LIST>){
    chomp;
    print "$_\t$rec_fpkm{$_}\n" if exists $rec_fpkm{$_};
}
