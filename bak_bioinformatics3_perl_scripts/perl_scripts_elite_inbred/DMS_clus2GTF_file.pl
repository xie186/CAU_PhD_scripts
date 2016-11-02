#!/usr/bin/perl -w
use strict;

my ($coor) = @ARGV ;
open COOR,$coor or die "$!";
while(<COOR>){
    chomp;
    my($chr,$stt,$end) = split;
    $_ =~ s/\t/_/g;
    print "$chr\txie\texon\t$stt\t$end\t.\t+\t.\ttranscript_id \"$_\_1\"; gene_id \"$_\"; gene_name \"$_\"\n";
}

