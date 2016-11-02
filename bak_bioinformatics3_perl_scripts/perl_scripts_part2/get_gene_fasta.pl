#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==2;
my($ge_fa,$gene)=@ARGV;

open GENE,$gene or die "$!";
my %hash_gene;
while(<GENE>){
    chomp;
    $hash_gene{$_} ++;
}

open SEQ,$ge_fa or die "$!";
my @aa=<SEQ>;
my $join=join'',@aa;
   @aa=split(/>/,$join);
shift @aa;
my %hash;
foreach(@aa){
    my ($name,@seq)=split(/\n/,$_);
       ($name)=split(/\s+/,$name); 
    my $seq=join '',@seq;
    print ">$name\n$seq\n" if exists $hash_gene{$name};
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Gene Seq> <gene name>
DIE
}
