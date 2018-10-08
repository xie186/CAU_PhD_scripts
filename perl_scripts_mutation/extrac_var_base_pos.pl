#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 3;
my ($vcf, $coor, $column) = @ARGV;

my @column = split(/:/, $column);
open COOR,$coor or die "$!";
my %coor;
while(<COOR>){
    chomp;
    my @coor = (split(/\t/, $_))[@column];
    $coor[0] = "chr".$coor[0];
    my $coor = join("\t", @coor);
    $coor{$coor} ++;
}
close COOR;

open VAR,$vcf or die "$!";
while(<VAR>){
    chomp;
    next if /^##/;
    print "$_\n" if /^#CHR/;
    my ($chr,$pos) = split;
    print "$_\n" if exists $coor{"$chr\t$pos"};
}

sub usage{
    my $die =<<DIE;
    perl *.pl <vcf> <snp _pos> <column [nCHR:nPOS]> 
DIE
}
