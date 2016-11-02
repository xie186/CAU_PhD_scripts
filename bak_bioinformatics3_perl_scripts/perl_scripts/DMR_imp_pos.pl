#!/usr/bin/perl -w
use strict;

my ($imp,$gene_pos)=@ARGV;
open POS,$gene_pos or die "$!";
my %hash;
while(<POS>){
    chomp; 
    my ($chr,$stt,$end,$gene,$strand)=split;
    $hash{$gene}=$_;
}

open IMP,$imp or die "$!";
while(<IMP>){
    chomp; 
    my ($chr,$stt,$end,$gene,$strand);
    ($gene)=split(/\t/,$_);
    if(/>IES/){
        ($chr,$stt,$end)=(split(/_/,$_))[1,2,3];
        $strand="NA";
    }else{
         ($chr,$stt,$end,$gene,$strand)=split(/\s/,$hash{$gene});
         $chr="chr".$chr;
    }
    print "$chr\t$stt\t$end\t$gene\t$strand\n";
}
