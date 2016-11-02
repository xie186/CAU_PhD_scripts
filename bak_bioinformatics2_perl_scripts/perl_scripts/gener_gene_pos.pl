#!/usr/bin/perl -w
use strict;

my ($gff)=@ARGV;
open GFF,$gff or die "$!";
while(<GFF>){
    chomp;
    my ($chr,$ele,$stt,$end,$strand,$gene)=(split)[0,2,3,4,6,8]; 
    next if $ele!~/gene/;
    ($gene)=$gene=~/ID\=(.*)\;Name/;
    print "$chr\t$stt\t$end\t$gene\t$strand\n";
}
