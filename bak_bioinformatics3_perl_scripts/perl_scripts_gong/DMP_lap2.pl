#!/usr/bin/perl -w
use strict;
my ($sam1,$sam2) = @ARGV;
my %hash_meth;
foreach($sam1,$sam2){
    open SAM,$_ or die "$!";
    while(<SAM>){
        chomp;
        my ($chr,$pos,$c_nu1,$t_nu1,$c_nu2,$t_nu2,$p_value) = split;
        push @{$hash_meth{"$chr\t$pos"}} ,"$c_nu1\t$t_nu1\t$c_nu2\t$t_nu2\t$p_value";
    }
}



