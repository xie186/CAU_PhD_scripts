#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==3;
my ($tab,$unique,$multi)=@ARGV;
open TAB,$tab or die "$!";
my %hash_id;
my %hash_len;
while(<TAB>){
    chomp;
    my ($id,$len,$copy)=split;
    ${$hash_id{$id}}[0]++;
    ${$hash_id{$id}}[1]=$len;
    ${$hash_id{$id}}[2]=$copy;
}
close TAB;

open TAB,$tab or die "$!";
open UNI,"+>$unique" or die "$!";
open MUL,"+>$multi" or die "$!";
while(<TAB>){
    chomp;
    my ($id)=split;
    if(${$hash_id{$id}}[0]==1){
        print UNI "$_\n";
    }else{
        print MUL "$_\n";
    }
}

foreach(keys %hash_id){
    print "$_\t${$hash_id{$_}}[1]\t${$hash_id{$_}}[2]\t${$hash_id{$_}}[0]\n";
}
sub usage{
    my $die=<<DIE;
    perl *.pl <smRNA table> <OUT unique mapped smRNAs> <multiple mapped smRNAs>   >> <smRNA statistic>
    We use this to sepatate uniquely mapped smRNAs and multiple mapped smRNA
DIE
}
