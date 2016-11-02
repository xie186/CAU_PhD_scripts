#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==4;
my ($rpkm,$fc,$out1,$out2)=@ARGV;
open RPKM,$rpkm or die "$!";
open SUB1,"+>$out1" or die "$!";
open SUB2,"+>$out2" or die "$!";
while(<RPKM>){
    chomp;
    my ($gene1,$sub1,$rpkm1,$gene2,$sub2,$rpkm2)=split;
    if($rpkm1/($rpkm2+0.0000001) >= $fc && $rpkm1 >= 1){
        print SUB1 "$_\n";
    }elsif($rpkm2/($rpkm1+0.0000001) >= $fc && $rpkm2 >= 1){
        print SUB2 "$_\n";
    }
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Dup RPKM> <Fold change> <Sub1 domin> <Sub2 Domin>
DIE
}
