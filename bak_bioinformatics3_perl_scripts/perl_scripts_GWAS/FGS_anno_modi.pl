#!/usr/bin/perl -w
use strict;

my ($anno) = @ARGV;
open ANNO,$anno or die "$!";
while(<ANNO>){
    chomp;
    my @ele = split(/\t/);
    $ele[1] = "--NA--" if $ele[1] !~/[a-z]/i;
    $ele[0] =~ s/FGP/FG/g;
    ($ele[0]) = split(/_/,$ele[0]) if $ele[0] =~ /GRMZM/;
    my $tem_anno = join("\t",@ele); 
    print "$tem_anno\n";
}


