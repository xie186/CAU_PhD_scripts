#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==3;
my ($alle1,$alle2,$admr)=@ARGV;
open ALLE1,$alle1 or die "$!";
my %hash_alle1;
while(<ALLE1>){
    chomp;
    my ($id,$len,$copy,$strd,$chrom,$pos)=split; 
    $hash_alle1{"$chrom\t$pos"}=$copy;
}

open ALLE2,$alle2 or die "$!";
my %hash_alle2;
while(<ALLE2>){
    chomp;
    my ($id,$len,$copy,$strd,$chrom,$pos)=split;
    $hash_alle2{"$chrom\t$pos"}=$copy;
}

open ADMR,$admr or die "$!";
while(<ADMR>){
    chomp;
    my ($chr,$stt,$end)=split;
    my ($smrna1,$smrna2)=(0,0);
    for(my $i=$stt;$i<=$end;++$i){
        $smrna1+=$hash_alle1{"$chr\t$i"} if exists $hash_alle1{"$chr\t$i"};
        $smrna2+=$hash_alle2{"$chr\t$i"} if exists $hash_alle2{"$chr\t$i"};
    }
    print "$_\t$smrna1\t$smrna2\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <smRNA wht snp 1> <smRNA wht snp allele 2> <aDMR> 
DIE
}
