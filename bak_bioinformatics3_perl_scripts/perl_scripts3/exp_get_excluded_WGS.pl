#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==2;
my ($fgs,$wgs)=@ARGV;
open FGS,$fgs or die "$!";
my %hash_fgs;
while(<FGS>){
    chomp;
    my ($chr,$stt,$end,$gene,$strand)=split;
       $hash_fgs{$gene}++;
}

open WGS,$wgs or die "$!";
while(<WGS>){
    chomp;
    my ($chr,$stt,$end,$gene,$strand)=split;
    print "$_\n" if !exists $hash_fgs{$gene};
}

sub usage{
    my $die=<<DIE;
    perl *.pl <FGS pos> <WGS pos>
DIE
}
