#!/usr/bin/perl -w
use strict;
my ($exp,$gff,$exp_gff,$noexp)=@ARGV;
die usage() unless @ARGV==4;
open EXP,$exp or die "$!";
my %hash;
while(<EXP>){
    chomp;
    my ($gene,$rpkm)=(split)[0,-1];
    $hash{$gene}=$rpkm;
}

open OUT1,"+>$exp_gff" or die;
open OUT2,"+>$noexp" or die;
open GFF,$gff or die;
while(<GFF>){
    next if /chromosome/;
    chomp;
    my ($chr,$ele,$pos1,$pos2,$strand,$name)=(split())[0,2,3,4,6,8];
    ($name)=(split(/=/,(split(/;/,$name))[0]))[1];
    $name=~s/_T\d+// if $name=~/GRMZM/;
    my @aa=split;
    $aa[-1]=$name;
    my $join=join("\t",@aa);
    if(exists $hash{$name}){
        print OUT1 "$join\t$hash{$name}\n";
    }else{
        print OUT2 "$join\n";
    }
}

sub usage{
    my $die=<<DIE;
    Usage:perl *.pl <EXP> <GFF > <EXP_GFF_OUT> <NOEXP_OUT>
DIE
}
