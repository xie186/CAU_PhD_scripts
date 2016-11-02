#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==1;
my ($geno)=@ARGV;
open GENO,$geno or die "$!";
my @aa=<GENO>;
my $join=join '',@aa;
   @aa=split(/>/,$join);
   shift @aa;
foreach(@aa){
#    next if (/^chrmitochondria/ || /^chrchloroplast/);
    my @seq=split(/\n/,$_);
    chomp @seq;
    my $chr=shift @seq; 
    my $sequence=join '',@seq;
    my $len=length $sequence;
    print "$chr\t$len\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <maize_geno> >genome_length
DIE
}
