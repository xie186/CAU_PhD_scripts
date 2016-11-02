#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 3;
my ($fpkm, $gene_module, $modules) = @ARGV;
open FPKM, "$fpkm" or die "$!";
my $header = <FPKM>;
chomp $header;
my %entropy;
while(my $line = <FPKM>){
    chomp $line;
    my ($gene, $entropy) = (split(/\t/,$line))[0,-1];
    $entropy{$gene} = $entropy;
}

my @modules = split(/,/, $modules);
my %modules;
foreach(@modules){
    $modules{$_}++;
}

open MODU,$gene_module or die "$!";
while(<MODU>){
    chomp;
    my ($gene,$modu_acc) = split;
    print "$gene\t$entropy{$gene}\n" if exists $modules{$modu_acc};
}
close MODU;

sub usage{
    my $die =<<DIE;
    perl *.pl <FPKM> <gene module> <modules>
DIE
}
