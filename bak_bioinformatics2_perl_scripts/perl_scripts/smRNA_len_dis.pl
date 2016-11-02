#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==1;
open FA,$ARGV[0] or die "$!";
my %hash;
while(<FA>){
    chomp;
    my ($id,$len,$copy)=split(/_/);
    ${$hash{$len}}[0]++;
    ${$hash{$len}}[1]+=$copy;
    <FA>;
}

foreach(sort{$a<=>$b} keys %hash){
    print "$_\t${$hash{$_}}[0]\t${$hash{$_}}[1]\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl  <FA> 
DIE
}
