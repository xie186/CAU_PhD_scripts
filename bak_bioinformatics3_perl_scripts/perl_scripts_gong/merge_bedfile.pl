#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==2;
my ($bed1, $bed2) = @ARGV;
$bed1 = "zcat $bed1|" if $bed1 =~ /.gz$/;
my %hash_count;
open BED,$bed1 or die "$!";
while(<BED>){
    chomp;
    my ($chr,$pos,$c_num, $tot, $lev) = split(/\t/, $_);
    $hash_count{"$chr\t$pos"} -> [0] = int($lev*$tot/100 + 0.5);
    $hash_count{"$chr\t$pos"} -> [1] = $tot;
}
close BED;

$bed2 = "zcat $bed2|" if $bed2 =~ /.gz$/;
open BED, $bed2 or die "$!";
while(<BED>){
    chomp;
    my ($chr,$pos,$c_num, $tot, $lev) = split(/\t/, $_);
    $hash_count{"$chr\t$pos"} -> [0] += int($lev*$tot/100 + 0.5);
    $hash_count{"$chr\t$pos"} -> [1] += $tot;
}

foreach(keys %hash_count){
    my ($c_num, $tot) = @{$hash_count{$_}};
    my $lev = $c_num*100/ $tot;
    print "$_\t$c_num\t$tot\t$lev\n";
}

sub usage{
    my $die =<<DIE;
    perl *.pl <bed1> <bed2> 
DIE
}
