#!/usr/bin/perl -w
use strict;

die "perl *.pl <SNP> \n" unless @ARGV==1;

open SNP,$ARGV[0] or die;
while(<SNP>){
    chomp;
    my @aa=split;
    if($aa[2] ne $aa[4] && $aa[2] ne $aa[6]){
        next;
    }elsif($aa[2] eq $aa[4]){
        print "$_\n";
    }else{
        print "$aa[0]\t$aa[1]\t$aa[2]\t$aa[3]\t$aa[6]\t$aa[7]\t$aa[4]\t$aa[5]\t$aa[-1]\n";
    }
}
