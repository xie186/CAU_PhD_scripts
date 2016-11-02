#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==4;
my ($junc_en,$junc_sd,$only_en,$only_sd)=@ARGV;
open EN,$junc_en or die "$!";
my %hash_en;
while(<EN>){
    chomp;
    my ($chr,$stt,$end,$gene)=split;
    push @{$hash_en{$gene}},$_;
}
close EN;

my %hash_sd;
open SD,$junc_sd or die "$!";
while(<SD>){
    chomp;
    my ($chr,$stt,$end,$gene)=split;
    push @{$hash_sd{$gene}},$_;
}

open ONLYEN,"+>$only_en" or die "$!";
foreach(keys %hash_en){
    next if exists $hash_sd{$_};
    foreach my $junc(@{$hash_en{$_}}){
        print ONLYEN "$junc\n";
    }
}

open ONLYSD,"+>$only_sd" or die "$!";
foreach(keys %hash_sd){
    next if exists $hash_en{$_};
    foreach my $junc(@{$hash_sd{$_}}){
        print ONLYSD "$junc\n";
    }
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Junction site in endosperm> <junction site in seedligns> <Junctions only in endosperm> <junctuions only in seedlings>
DIE
}
