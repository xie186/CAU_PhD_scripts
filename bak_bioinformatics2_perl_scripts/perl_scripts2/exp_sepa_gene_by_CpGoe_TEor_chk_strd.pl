#!/usr/bin/perl -w
use strict;
my ($exp,$gff,$out1,$out2,$out3,$out4)=@ARGV;
die usage() unless @ARGV==6;
open EXP,$exp or die "$!";
my %hash;
while(<EXP>){
    chomp;
    my ($gene,$rpkm,$cpg_oe,$te,$strand)=(split)[0,3,4,5,6];
    @{$hash{$gene}}=($rpkm,$cpg_oe,$te,$strand);
}

open OUT1,"+>$out1" or die;
open OUT2,"+>$out2" or die;
open OUT3,"+>$out3" or die;
open OUT4,"+>$out4" or die;
open GFF,$gff or die;
while(<GFF>){
    next if /chromosome/;
    chomp;
    my ($chr,$ele,$pos1,$pos2,$strand,$name)=(split())[0,2,3,4,6,8];
    ($name)=(split(/=/,(split(/;/,$name))[0]))[1];
    $name=~s/_T\d+// if $name=~/GRMZM/;
    next if !exists $hash{$name};
    my @aa=split;
    if(${$hash{$name}}[1]<0.9 && ${$hash{$name}}[2] eq "TE" && $strand eq ${$hash{$name}}[3]){
        print OUT1 "$chr\t$ele\t$pos1\t$pos2\t$strand\t$name\t${$hash{$name}}[0]\n";
    }elsif(${$hash{$name}}[1]<0.9 && ${$hash{$name}}[2] eq "TE" && $strand ne ${$hash{$name}}[3]){
        print OUT2 "$chr\t$ele\t$pos1\t$pos2\t$strand\t$name\t${$hash{$name}}[0]\n";
    }elsif(${$hash{$name}}[1]>=0.9 && ${$hash{$name}}[2] eq "TE" && $strand eq ${$hash{$name}}[3]){
        print OUT3 "$chr\t$ele\t$pos1\t$pos2\t$strand\t$name\t${$hash{$name}}[0]\n";
    }elsif(${$hash{$name}}[1]>=0.9 && ${$hash{$name}}[2] eq "TE" && $strand ne ${$hash{$name}}[3]){
        print OUT4 "$chr\t$ele\t$pos1\t$pos2\t$strand\t$name\t${$hash{$name}}[0]\n";
    }else{
        print "Wrong!";
    }
}

sub usage{
    my $die=<<DIE;
    \nUsage:perl *.pl <EXP> <GFF > <Low CpG && TE identical >  <Low CpG && TE not identical> <High CpG && TE ident> <High CpG && TE not identical>\n
DIE
}
