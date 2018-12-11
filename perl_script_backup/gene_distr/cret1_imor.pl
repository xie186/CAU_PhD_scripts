#!/usr/bin/perl -w
use strict;

while(<>){
    chomp;
    my @aa=split;
    if($aa[-1]<=0.05 && $aa[-2]<=0.05){
       my $imor=&cret1($aa[2],$aa[3],$aa[4],$aa[5]);
       print "$_\t$imor\n";
    }
}

sub cret1{
    my $return;
    if($_[0]/($_[0]+$_[1])>2/3 && $_[3]/($_[2]+$_[3])>2/3){
        $return="mat";
    }elsif($_[1]/($_[0]+$_[1])>1/3 && $_[2]/($_[2]+$_[3])>1/3){
        $return="pat";
    }else{
         $return="NO";
    }
    return $return;
}
