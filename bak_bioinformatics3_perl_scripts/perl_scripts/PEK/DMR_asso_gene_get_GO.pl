#!/usr/bin/perl -w
use strict;
my ($dmr_gene,$go)=@ARGV;
die usage() unless @ARGV==2;
open DMR,$dmr_gene or die "$!";
my %hash;
while(<DMR>){
    chomp;
    $hash{$_}++;
}

open GO,$go or die "$!";
while(<GO>){
    chomp;
    my ($name)=split;
    print "$_\n" if exists $hash{$name};
}

sub usage{
    my $die=<<DIE;
    Usage:perl *.pl <DMR associate> <Gene Ontology>
DIE
}
