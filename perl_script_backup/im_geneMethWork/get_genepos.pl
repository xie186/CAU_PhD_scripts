#!/usr/bin/perl/ -w
use strict;

die "perl *.pl <Imgene><Geneposition>\n" unless @ARGV==2;
my %xx;
open NM,$ARGV[0] or die "$!";
while(my $nm=<NM>){
    chomp $nm;
    $xx{$nm}=0;
#    if($nm=~/^IES/){
#        my $ies=(split(/\s+/,$nm))[0];
#        my @pos=split(/_/,$ies);
#        $pos[1]=~s/chr//;
#        print "$ies\t$pos[1]\t$pos[2]\t$pos[3]\n";
#    }
} 

open POS,$ARGV[1] or die "$!";
while(my $pos=<POS>){
    chomp $pos;
    my @aa=split(/\s+/,$pos);
    if(exists $xx{$aa[3]}){
        print "$aa[3]\t$aa[0]\t$aa[1]\t$aa[2]\t$aa[4]\n";
    }
} 
close POS;
