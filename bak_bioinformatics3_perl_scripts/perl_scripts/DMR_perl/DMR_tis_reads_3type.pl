#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==2;
my ($rpkm,$gene_pos)=@ARGV;
open GE,$gene_pos or die "$!";
my %hash;
while(<GE>){
    chomp;
    my ($chr,$stt,$end,$gene,$strand,$type)=split;
    $hash{$gene}=$type;
}

open RPKM,$rpkm or die "$!";
my %hash_reads;
while(<RPKM>){
    chomp;
    my ($gene,$cdna_len,$read_nu,$rpkm_value)=split;
    $hash_reads{$hash{$gene}}+=$read_nu;
}

foreach(sort keys %hash_reads){
    print "$_\t$hash_reads{$_}\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <RPKM file> <Gene position with type>
DIE
}
