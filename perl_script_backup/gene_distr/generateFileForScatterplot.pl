#!/usr/bin/perl 
use strict;
die "perl *.pl <All_im><Scatter_1><Scatter_NC>" unless @ARGV==3;
open ALL,$ARGV[0] or die;
open GENE,"+>$ARGV[1]" or die;
open NC,"+>$ARGV[2]" or die;
while(<ALL>){
    chomp;
    my @aa=split;
    if($aa[0]=~/Zm[MP]NC/ || $aa[0]=~/^IES/){
        if($aa[-1] eq 'mat'){
            print NC "zeam$aa[1]\t$aa[2]\t$aa[3]\t0.1\n";
        }else{
            print NC "zeam$aa[1]\t$aa[2]\t$aa[3]\t0.0\n";
        }
    }else{
        if($aa[-1] eq 'mat'){
            print GENE "zeam$aa[1]\t$aa[2]\t$aa[3]\t0.3\n";
        }else{
            print GENE "zeam$aa[1]\t$aa[2]\t$aa[3]\t0.2\n";
        }
    }
}
