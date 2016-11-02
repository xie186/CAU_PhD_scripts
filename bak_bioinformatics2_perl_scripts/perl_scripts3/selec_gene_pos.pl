#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==2;
my ($pos,$sel)=@ARGV;
open POS,$pos or die "$!";
my %hash;
while(<POS>){
    chomp;
    my ($chr,$stt,$end,$gene,$strand)=split;
    $hash{$gene}=$_;
}

open SEL,$sel or die "$!";
while(<SEL>){
    chomp;
    print "$hash{$_}\n" if exists  $hash{$_};
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Gene position> <Selected gene>
DIE
}
