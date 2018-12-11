#!/usr/bin/perl -w
use strict;

open DO,$ARGV[0]  or die;
#<DO>;
my %target;
while(<DO>){
    chomp;
 #   my $gene=(split(/\s+/,$_))[0];
  #  print "$gene\n";
    $target{$_}=0;
}
close DO;

open PRO,$ARGV[1] or die;
my @all    =<PRO>;
my $allseq =join('',@all);
my @geneseq=split(/>/,$allseq);

foreach(@geneseq){
    my $tempName=(split(/\|/,$_))[0];
    #print "$_" unless (defined $tempName);
    if(defined $tempName && exists $target{$tempName}){
#        delete $target{$tempName};
        print ">$_";
    }
}
