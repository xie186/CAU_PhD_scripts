#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==2;

my ($syn_gene,$fgs_gene) = @ARGV;
open SYN,$syn_gene or die "$!";
my %hash_syn;
while(<SYN>){
    chomp;
    my ($zm_gene,$rice_gene) = split;
    $hash_syn{$zm_gene}++;
    $hash_syn{$rice_gene}++;
}

open FGS,$fgs_gene or die "$!";
while(<FGS>){
    my ($chr,$stt,$end,$gene) = split;
    print "$_" if exists $hash_syn{$gene};
}

sub usage{
    print <<DIE;
    perl *.pl <Syntenic genes> <FGS genes> 
DIE
    exit 1;
}
