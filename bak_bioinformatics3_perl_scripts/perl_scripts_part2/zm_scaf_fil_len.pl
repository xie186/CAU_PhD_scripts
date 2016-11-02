#!/usr/bin/perl -w
use strict;

my ($seq,$len_cut) = @ARGV;
open SEQ,$seq or die "$!";
while(my $id = <SEQ>){
    print "$id\n";
    my ($seq) = <SEQ>;
    chomp $seq;
    my $len = length $seq;
    print "$id" if $len > $len_cut;
}
