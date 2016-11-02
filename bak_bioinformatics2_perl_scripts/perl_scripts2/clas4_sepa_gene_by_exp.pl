#!/usr/bin/perl -w
use strict;
my ($gene_pos,$gff,$out)=@ARGV;
die usage() unless @ARGV==4;
open POS,$gene_pos or die "$!";
while(<POS>){
    chomp;
    my 
}
open GFF,$gff or die;
while(<GFF>){
    next if /chromosome/;
    chomp;
    my ($chr,$ele,$pos1,$pos2,$strand,$name)=(split())[0,2,3,4,6,8];
    ($name)=(split(/=/,(split(/;/,$name))[0]))[1];
    $name=~s/_T\d+// if $name=~/GRMZM/;
    next if !exists $hash{$name};
    my @aa=split;
    $aa[-1]=$name;
    my $join=join("\t",@aa);
    
    print OUT1 "$join\t$hash{$name}\n" if $hash{$name}>0;
    
    print OUT2 "$join\n" if $hash{$name}==0;
}

sub usage{
    my $die=<<DIE;
    Usage:perl *.pl <EXP> <GFF > <EXP_GFF_OUT> <NOEXP_OUT>
DIE
}
