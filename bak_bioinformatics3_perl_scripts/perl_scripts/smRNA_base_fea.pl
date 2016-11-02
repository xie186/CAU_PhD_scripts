#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==2;
my ($tab,$raw)=@ARGV;
open TAB,$tab or die "$!";
my %hash;
while(<TAB>){
    chomp;
    my ($id)=split;
    $hash{"t$id"}++;
}

open RAW,$raw or die "$!";
while(<RAW>){
    chomp;
    my ($id,$len,$bu)=split(/_/);
    $id=~s/>//;
    my $seq=<RAW>;
    print "$_\n$seq" if exists $hash{$id};
}

sub usage{
    my $die=<<DIE;
    perl *.pl <TAB > <Raw sequence>
DIE
}
