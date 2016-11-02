#!/usr/bin/perl -w
use strict;
my ($exp,$gff,$out_gff)=@ARGV;
die usage() unless @ARGV==3;
open EXP,$exp or die "$!";
my %hash;
while(<EXP>){
    chomp;
    next if !/^\d/;
    my ($gene,$rpkm)=(split)[3,-1];
    $hash{$gene}=$rpkm;
}

open OUT1,"+>$out_gff" or die;
open GFF,$gff or die;
while(<GFF>){
    next if /chromosome/;
    chomp;
    my ($chr,$ele,$pos1,$pos2,$strand,$name)=(split)[0,2,3,4,6,8];
    ($name)=(split(/=/,(split(/;/,$name))[0]))[1];
    $name=~s/_T\d+// if $name=~/GRMZM/;
    next if !exists $hash{$name};
    my @aa=split;
    $aa[-1]=$name;
    my $join=join("\t",@aa);
    print OUT1 "$chr\t$ele\t$pos1\t$pos2\t$strand\t$name\t$hash{$name}\n";
}

sub usage{
    my $die=<<DIE;
    Usage:perl *.pl <EXP> <GFF > <GFF_OUT> 
DIE
}
