#!/usr/bin/perl -w
use strict;
my ($mat,$pat) = @ARGV;

die usage() unless @ARGV==2;
my %hash_imp;
open MAT,$mat or die "$!";
while(<MAT>){
    chomp;
    $hash_imp{$_} ++;
}

open PAT,$pat or die "$!";
while(<PAT>){
    chomp;
    $hash_imp{$_} ++;
}

foreach(keys %hash_imp){
#    print "$hash_imp{$_}\n";
    print "$_\n" if $hash_imp{$_} ==2;
}

sub usage{
    my $die =<<DIE;
    perl *.pl <mat> <pat> 
DIE
}
