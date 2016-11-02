#!/usr/bin/perl -w
use strict;

my ($gene,$fpkm,$gff) = @ARGV;

open FPKM, $fpkm or die "$!";
<FPKM>;
my %hash_fpkm;
while(<FPKM>){
    chomp; 
    my ($ge_id,$fpkm_val) = (split)[0,9];
    $hash_fpkm{$ge_id} = $fpkm_val;
}

my %hash_gene;
open GENE,$gene or die "$!";
while(<GENE>){
    next if !/^\d/;
    my ($chr,$stt,$end,$ge_id,$strand) = split;
    if(exists $hash_fpkm{$ge_id}){
        $hash_gene{$ge_id} = $hash_fpkm{$ge_id};
    }else{
         print "error\n"
         $hash_gene{$ge_id} = 0;
    }
}

