#!/usr/bin/perl -w
use strict;

my ($te, $te_name) = @ARGV;

my %rec_type;
my %rec_num;
open TE, $te or die "$!";
while(<TE>){
    chomp;
    my ($name, $strand, $stt, $end, $family, $super) = split;
    $rec_num{$super} = 0;
    $rec_type{$name} = $super;
}

open NAME, $te_name or die "$!";
my %flag;
while(<NAME>){
    chomp;
    $flag{$_} ++;
    if($flag{$_} ==1){
        my $super = $rec_type{$_};
        $rec_num{$super} ++;
    }
}

foreach(sort keys %rec_num){
     print "$_\t$rec_num{$_}\n";
}
