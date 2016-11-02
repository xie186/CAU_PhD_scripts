#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==2;
my ($sd_rpkm,$endo_rpkm)=@ARGV;

open SD,$sd_rpkm or die "$!";
my %hash;
while(<SD>){
    chomp;
    my ($gene,$rpkm)=(split)[0,-1];
    $hash{$gene}=$_;
}

open ENDO,$endo_rpkm or die "$!";
while(<ENDO>){
    chomp;
    my ($gene)=split;
    print "$hash{$gene}\t$_\n" if exists $hash{$gene};
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Seedlings RPKM> <Endoserm RPKM>
DIE
}
