#!/usr/bin/perl -w
use strict;

my $read;
my $lev;
my $context;
my $i=0;
while(<>){
    chomp;
    my @aa=split;
    $aa[3]=~s/(\w+)://;
    if($1 eq "CG" && $aa[3]>=3){ 
        $read+=$aa[3];
        $lev +=$aa[4];
        $context=$1;
        $i++;
    }
}

my $aver=$lev/$read;
my $dept=$read/$i;
print "$context\t$dept\t$lev\t$aver\n";
