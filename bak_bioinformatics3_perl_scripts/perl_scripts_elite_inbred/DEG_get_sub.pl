#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==2;
my ($list, $deg_pos) = @ARGV;
my %gene_list;
open LIST, $list or die "$!";
while(<LIST>){
    chomp;
    next if !/^\w/;
    my ($gene) = split(/\s+/,$_);
    $gene_list{$gene} ++;
}

open DEG,$deg_pos or die "$!";
while(<DEG>){
    chomp;
    my ($chr,$stt,$end,$gene)  = split;
    print "$_\n" if exists $gene_list{$gene};
}

sub usage{
    my $die = <<DIE;
    perl *.pl <List> <DEG position> 
DIE
}
