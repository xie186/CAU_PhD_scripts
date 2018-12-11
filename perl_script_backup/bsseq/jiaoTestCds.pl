#!/usr/bin/perl -w
use strict;
open NEW,$ARGV[0] or die;
my %newv;
while(my $new=<NEW>){
    chomp $new;
    my ($newnm)=(split(/\s+/,$new))[0];
    my $seq=<NEW>;
    $newv{$seq}=0;
}

close NEW;

open OLD,$ARGV[1] or die;
while(my $old=<OLD>){
    chomp $old;
    my ($oldnm)=(split(/\s+/,$old))[0];
    my $seq=<OLD>;
    if(exists $newv{$seq}){
        print "$seq\n";
    }
} 
