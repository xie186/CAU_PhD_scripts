#!/usr/bin/perl -w
use strict;
my ($fgs,$mutant)=@ARGV;

open FGS,$fgs or die  "$!";

my %hash;
while(<FGS>){
    chomp;
    my ($chr,$stt,$end,$name,$cpg_oe)=(split(/\t/,$_))[0,1,2,3,11];
    $hash{$name}=$cpg_oe;
}

open MUT,$mutant or die "$!";
while(<MUT>){
    chomp;
    my ($name)=split;
    print "$name\t$hash{$name}\n" if exists $hash{$name};
}
