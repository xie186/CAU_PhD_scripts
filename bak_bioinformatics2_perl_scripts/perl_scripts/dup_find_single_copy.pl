#!/usr/bin/perl -w
use strict;
my ($blat_res)=@ARGV;
die usage() unless @ARGV==1;
open BLAT,$blat_res or die "$!";
my %hash_name;
my %hash_hit;
while(<BLAT>){
    chomp;
    my ($gene1,$gene2,$e_value)=(split)[0,1,-2];
    ($gene1)=split(/_/,$gene1) if $gene1=~/^GRM/;
    ($gene2)=split(/_/,$gene2) if $gene2=~/^GRM/;
    $hash_name{$gene1}++;
    next if $e_value>=0.1;
    $hash_hit{$gene1}++ if $gene1 ne $gene2;
}

foreach(keys %hash_name){
    next if exists $hash_hit{$_};
    print "$_\n";
}

sub usage{
    my $die=<<DIE;
\n    perl *.pl <Blast search [All-again-all search]>
    To identify single copy genes.
\n
DIE
}
