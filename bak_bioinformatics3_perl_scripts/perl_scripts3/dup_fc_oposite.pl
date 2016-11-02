#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==4;
my ($sd,$em,$out1,$out2)=@ARGV;
open SD,$sd or die "$!";
my %hash1;
while(<SD>){
    chomp;
    my ($gene1,$rpkm1,$gene2,$rpkm2)=(split)[2,3,4,5];
    if($rpkm1>$rpkm2){
        $hash1{"$gene1\t$gene2"}=$_;
    }else{
        $hash1{"$gene2\t$gene1"}=$_;
    }
}

open EM,$em or die "$!";
my %hash2;
while(<EM>){
    chomp;
    my ($gene1,$rpkm1,$gene2,$rpkm2)=(split)[2,3,4,5];
    if($rpkm1>$rpkm2){
        $hash2{"$gene1\t$gene2"}=$_;
    }else{
        $hash2{"$gene2\t$gene1"}=$_;
    }
}

open OUT1,"+>$out1" or die "$!";
open OUT2,"+>$out2" or die "$!";
foreach(keys %hash1){
    my ($gene1,$gene2)=split;
    next if !exists $hash2{"$gene2\t$gene1"};
    print OUT1 "$hash1{$_}\n";
    print OUT2 "$hash2{\"$gene2\t$gene1\"}\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <sd> <em> <OUT1> <OUT2>
DIE
}
