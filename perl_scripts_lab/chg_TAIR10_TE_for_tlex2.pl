#!/usr/bin/perl -w
use strict;
my ($file) = @ARGV;
#AT1TE52125      false   15827287        15838845        ATHILA2 LTR/Gypsy
open FILE,$file or die "$!";
<FILE>;
while(<FILE>){
    chomp;
    my ($id, $strand, $stt,$end) = split;
    my ($chr) =$id =~ /AT(\d+)TE/;
    $chr = "chr".$chr;
    $strand =~ s/false/-/g;
    $strand =~ s/true/+/g;
    print "$id\t$chr\t$stt\t$end\t$strand\n";
}
