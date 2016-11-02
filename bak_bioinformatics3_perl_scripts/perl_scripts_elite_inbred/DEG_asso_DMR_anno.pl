#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 3;
my ($cg, $chg, $anno) = @ARGV;
my %dmr_deg;
my %cg_dmr_deg;
open CG,$cg or die "$!";
while(<CG>){
    chomp;
    my ($chr,$stt,$end,$gene,$strand) = split;
    $cg_dmr_deg{$gene} ++;
    $dmr_deg{$gene} ++;
}

my %chg_dmr_deg;
open CHG,$chg or die "$!";
while(<CHG>){
    chomp;
    my ($chr,$stt,$end,$gene,$strand) = split;
    $chg_dmr_deg{$gene} ++;
    $dmr_deg{$gene} ++;
}

my %gene_anno;
open ANNO,$anno or die "$!";
while(<ANNO>){
    chomp;
    #GRMZM2G319109	AT1G03160	LOC_Os05g32390	No	Yes	FZO-like &&.FZL, putative, expressed
    my ($gene, $ara, $rice, $dot1, $dot2, $product)  = split(/\t/);
    $gene_anno{$gene} = "$gene\t$ara\t$rice\t$product";
}

foreach(keys %dmr_deg){
    my ($cg_stat, $chg_stat) = &jug_stat($_);
    if(exists $gene_anno{$_}){
        print "$gene_anno{$_}\t$cg_stat\t$chg_stat\n";
    }else{
        print "$_\tXX\tXX\tXX\t$cg_stat\t$chg_stat\n";
    }
}

sub jug_stat{
    my ($gene) = @_;
    my ($cg_stat, $chg_stat) = ("Yes", "Yes");
    if(!exists $cg_dmr_deg{$_}){
        $cg_stat = "No";
    }
    if(!exists $chg_dmr_deg{$_}){
        $chg_stat = "No";
    }
    return ($cg_stat, $chg_stat);
}

sub usage{
    my $die =<<DIE;
    perl *.pl <DEG CG DMR> <DEG CHG DMR> <anno> 
DIE
}
