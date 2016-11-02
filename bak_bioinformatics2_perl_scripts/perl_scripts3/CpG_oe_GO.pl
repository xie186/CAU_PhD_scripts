#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==2;
my ($go,$gene)=@ARGV;

open GO,$go or die "$!";
my %hash;
while(<GO>){
    chomp;
    my ($name)=split;
    $hash{$name}=$_;
}

open GENE,$gene or die "$!";
while(<GENE>){
    chomp;
    print "$hash{$_}\n" if exists $hash{$_};
}

sub usage{
    my $die=<<DIE;
    perl *.pl <GO> <Gene>
DIE
}
