#!/usr/bin/perl -w
use strict;
my ($exp,$cpg_oe,$gff,$low_exp,$low_expno,$hi_exp,$hi_expno)=@ARGV;
die usage() unless @ARGV==7;
open EXP,$exp or die "$!";
my %hash;
while(<EXP>){
    chomp;
    my ($gene,$rpkm)=(split)[0,-1];
    $hash{$gene}=$rpkm;
}

open CPG,$cpg_oe or die "$!";
my %hash_oe;
while(<CPG>){
    chomp;
    my ($chr,$stt,$end,$gene,$oe_value)=(split)[0,1,2,3,11];
    $hash_oe{$gene}=$oe_value;
}

open OUT1,"+>$low_exp" or die;
open OUT2,"+>$low_expno" or die;
open OUT3,"+>$hi_exp" or die;
open OUT4,"+>$hi_expno" or die;
open GFF,$gff or die;
while(<GFF>){
    chomp;
    my ($chr,$ele,$pos1,$pos2,$strand,$name)=(split)[0,2,3,4,6,8];
    ($name)=(split(/=/,(split(/;/,$name))[0]))[1];
    $name=~s/_T\d+// if $name=~/GRMZM/;
    next if($ele eq "gene" || $ele eq "chromosome");
    next if !exists $hash_oe{$name};
    my @aa=split;
    $aa[-1]=$name;
    my $join=join("\t",@aa);
    if($hash_oe{$name}<0.9){
        if(!exists $hash{$name}){
            print OUT2 "$join\t0\n";
        }else{
            print OUT1 "$join\t$hash{$name}\n";
        }
    }else{
        if(!exists $hash{$name}){
            print OUT4 "$join\t0\n";
        }else{
            print OUT3 "$join\t$hash{$name}\n";
        }    
    }
    
}

sub usage{
    my $die=<<DIE;
    Usage:perl *.pl <RPKM > <CpG OE of gene> <GFF > <Low-exp> <Low-non-exp> <High-exp> <High-non-exp> 
DIE
}
