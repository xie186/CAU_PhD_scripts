#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==3;
my ($sd_pair,$endo_pair,$cutoff)=@ARGV;
open SD,$sd_pair or die "$!";
my %hash;
while(<SD>){
    chomp;
    my ($gene1,$rpkm1,$gene2,$rpkm2)=(split)[2,3,4,5];
    next if($rpkm1<$cutoff || $rpkm2<$cutoff);
    $hash{"$gene1\t$gene2"}=$_;
}

open ENDO,$endo_pair or die "$!";
while(<ENDO>){
    chomp;
    my ($gene1,$rpkm1,$gene2,$rpkm2)=(split)[2,3,4,5];
    next if($rpkm1<$cutoff || $rpkm2<$cutoff);
    if(exists $hash{"$gene1\t$gene2"}){
        my $sd_info=$hash{"$gene1\t$gene2"};
        print "$sd_info\t$_\n";
    }
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Seedlings> <Endosperm> <cutoff>
DIE
}
