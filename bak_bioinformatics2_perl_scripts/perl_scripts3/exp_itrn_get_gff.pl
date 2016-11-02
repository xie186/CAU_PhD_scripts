#!/usr/bin/perl -w
use strict;
my ($gene_pos,$gff,$out)=@ARGV;
die usage() unless @ARGV==3;

open POS,$gene_pos or die "$!";
my %hash;
while(<POS>){
    chomp;
    next if /^##/;
    my ($chr,$stt,$end,$name,$strand,$type)=split;
    $hash{$name}++;
}
close POS;

open OUT,"+>$out" or die "$!";
open GFF,$gff or die;
while(<GFF>){
    next if /^##/;
    next if /chromosome/;
    chomp;
    my ($chr,$ele,$pos1,$pos2,$strand,$name)=(split)[0,2,3,4,6,8];
    ($name)=(split(/=/,(split(/;/,$name))[0]))[1];
    $name=~s/_T\d+// if $name=~/GRMZM/;
    next if !exists $hash{$name};
    print OUT "$chr\t$ele\t$pos1\t$pos2\t$strand\t$name\t$hash{$name}\n";
}

sub usage{
    my $die=<<DIE;
    Usage:perl *.pl <gene position> <GFF > <GFF with rank>
DIE
}
