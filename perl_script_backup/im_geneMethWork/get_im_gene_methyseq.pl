#!/usr/bin/perl -w
use strict;

open GENE,$ARGV[1] or die;
while(<GENE>){
    chomp;
    my @aa=split;
    my $chr=">chr".$aa[1];
    open OUT,"+>$aa[0].fa"; 
    open GENO,$ARGV[0] or die;
    while(my $geno=<GENO>){
        chomp $geno;
        my $seq=<GENO>;
        if($geno eq $chr){
          #  open OUT,"$aa[0].fa";
            my $tar=substr($seq,$aa[2]-3000,$aa[3]+6000-$aa[2]);
            print OUT ">$aa[0]\n$tar\n";
           # close OUT;
        }
    }
    close OUT;
}
close GENO;
close GENE;
