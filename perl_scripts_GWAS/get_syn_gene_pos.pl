#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==2;
my ($syn,$gene_pos) = @ARGV;
open SYN,$syn or die "$!";
my %hash_syn;
while(<SYN>){
    chomp;
    my ($gene1,$gene2) = split;
    $hash_syn{$gene1}++;
    $hash_syn{$gene2}++;
}

open POS,$gene_pos or die "$!";
while(<POS>){
    chomp;
    next if !/^\d/;
    my ($chr,$stt,$end,$gene,$strand) = split;
    print "chr$_\n" if ($chr == 1 && !exists $hash_syn{$gene});
}

sub usage{
    print <<DIE;
    perl *.pl <Syntenic genes> <Gene position> 
DIE
    exit 1;
}
