#!/usr/bin/perl -w
use strict;
my ($imp,$region)=@ARGV;
die usage() unless @ARGV==2;

open REGION,$region or die "$!";
my %hash_ana;
while(<REGION>){
    chomp;
    my ($chr,$stt,$end)=split;
    my $mid=int (($end+$stt)/2);
    $hash_ana{"$chr\t$mid"}++;
}

open IMP,$imp or die "$!";
my %total;
my %analyzed;
while(<IMP>){
    chomp;
    my ($chr,$stt,$end)=split;
    $total{$_}++;
    for(my $i=$stt-2000;$i<=$end+2000;++$i){
        $analyzed{$_}++ if exists $hash_ana{"$chr\t$i"};
    }
}

my $total=keys %total;
my $analyzed=keys %analyzed;
foreach(keys %analyzed){
    print "$_\n";
}
print "$analyzed\t$total\n";

sub usage{
    my $die=<<DIE;
    perl *.pl <Imprinted gene name> <Regions can be analyzed>
DIE
}
