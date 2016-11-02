#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==1;
my ($sect_res) = @ARGV;
open SECT,$sect_res or die "$!";
my %hash_stat;
while(<SECT>){
    chomp;
    my ($chr,$stt,$end,$context,$ele_chr,$ele_stt,$ele_end) = split;
#    my $mid = $end - 2000;
    my $ele_mid = int (($ele_stt + $ele_end)/2);
    next if $ele_mid < $stt;
    next if $ele_mid > $end;
    my $pos = int (($ele_mid - $stt)/100) - 20;
    next if $pos == 20;
    $hash_stat{"$context"} -> {$pos} ++;
}

foreach my $context(keys %hash_stat){
    foreach my $pos(sort {$a <=> $b} keys %{$hash_stat{"$context"}}){
        print "$context\t$pos\t$hash_stat{\"$context\"}->{$pos}\n";
    }
}

sub usage{
    my $die =<<DIE;
    perl *.pl <TFBS intersect results>
DIE
}
