#!/usr/bin/perl -w
use strict;

open WK,$ARGV[0] or die;
while(my $nm=<WK>){
    my $seq=<WK>;
    my ($nm)=(split(/\s+/,$nm))[0];
    $nm=~s/>//;
    
    open PRO,$ARGV[1] or die;
    while (my $pronm=<PRO>){
        next if !$pronm=~/^>/;
        if((my $find=index($pronm,$nm,0))>-1){
            print ">$nm\n$seq";
        }
    }
}
