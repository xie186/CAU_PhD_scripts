#!/usr/bin/perl -w
use strict;
open IMMARK,$ARGV[0] or die;

while(my $im=<IMMARK>){
    chomp $im;
    my @array=(split(/\s+/,$im));
    my $ies=(split(/\>/,$array[4]))[1];
    open OUT,"+>>paternal_50k_genenm" or die;
    print OUT "$array[4]\n";
    if(@array/5==1){
         next;
    }else{
       for(my $i=1;$i<@array/5;++$i){
            print OUT "$array[5*$i]\t$array[5*$i+1]\t$array[5*$i+2]\t$array[5*$i+3]\t$array[5*$i+4]\n"; 
        }
    }
    print OUT "=================================\n";
    close OUT;

}
