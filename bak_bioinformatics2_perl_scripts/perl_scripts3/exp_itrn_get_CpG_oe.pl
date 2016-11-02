#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==2;
my ($fgs,$gff)=@ARGV;

open FGS,$fgs or die "$!";
my %cpg_oe;
while(<FGS>){
    chomp;
    my ($chr,$stt,$end,$name,$strand,$cpg_oe)=(split)[0,1,2,3,4,11];
    $cpg_oe{$name}=$cpg_oe;
}

open GFF,$gff or die "$!";
while(<GFF>){
    chomp;
    my ($chr,$stt,$end,$gene)=split;
    print "$_\t$cpg_oe{$gene}\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Filter gene set with CpG O/E> <gff>
DIE
}
