#!/usr/bin/perl -w
use strict;
my ($sd,$endo,$out)=@ARGV;
open SD,$sd or die "$!";
my %hash;
while(<SD>){
    chomp;
    my ($ge1,$rpkm1,$ge2,$rpkm2)=(split)[2,3,4,5];
    if($rpkm1>$rpkm2){
        $hash{"$ge1\t$ge2"}++;
    }else{
        $hash{"$ge2\t$ge1"}++;
    }
}

open ENDO,$endo or die "$!";
open OUT,"+>$out" or die "$!";
while(<ENDO>){
    chomp; 
    my ($ge1,$rpkm1,$ge2,$rpkm2)=(split)[2,3,4,5];
    print "$_\n" if (exists $hash{"$ge2\t$ge1"} || exists $hash{"$ge1\t$ge2"});
    if($rpkm1>$rpkm2){
        print OUT "$_\n" if exists $hash{"$ge2\t$ge1"};
    }else{
        print OUT "$_\n" if exists $hash{"$ge1\t$ge2"};
    }
}
