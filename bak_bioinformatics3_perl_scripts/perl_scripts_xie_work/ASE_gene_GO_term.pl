#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my ($go_term,$deg_cand) = @ARGV;
open GO, $go_term or die "$!";
my %hash_go;
while(<GO>){
    chomp;
    my ($gene) = split;
    $hash_go{$gene} = $_;
}


open CAND,$deg_cand or die "$!";
while(<CAND>){
    next if /^id/; 
    my ($id) = split;
    print "$hash_go{$id}\n";
}  

sub usage{
    my $die =<<DIE;
    perl *.pl <GO term> <ASE genes> 
DIE
}
