#!/usr/bin/perl -w
use strict;
my ($deg_gene,$gff,$DEG_gff)=@ARGV;
die usage() unless @ARGV==3;
open DEG,$deg_gene or die "$!";
my %hash_DEG;
while(<DEG>){
    chomp;
    my ($gene)=split;
    $hash_DEG{$gene}++;
}

open OUT1,"+>$DEG_gff" or die;
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
    if(exists $hash_DEG{$name}){
        print OUT1 "$join\n";
    }
}

sub usage{
    my $die=<<DIE;
    Usage:perl *.pl <DEG gene> <GFF > <DEG_GFF_OUT> 
DIE
}
