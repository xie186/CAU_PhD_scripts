#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==6;
my ($gene_pos,$windows,$step,$forw,$rev,$out)=@ARGV;

open LEN,$gene_pos or die "$!";
my %hash;
while(<LEN>){
    chomp;
    my ($chr,$stt,$end,$gene)=split;
    @{$hash{$gene}}=($chr,$stt,$end);
}

my %meth_hash;
open FORW,$forw or die "$!";
while(<FORW>){
    chomp;
    my ($chr,$pos1,$pos2,$depth,$lev)=split;
    next if $depth<3;
    $meth_hash{"$chr\t$pos1"}=$lev;
}

open REV,$rev or die "$!";
while(<REV>){
    chomp;
    my ($chr,$pos1,$pos2,$depth,$lev)=split;
    next if $depth<3;
    $meth_hash{"$chr\t$pos1"}=$lev;
}

open OUT,"+>$out" or die "$!";
foreach (sort keys %hash){
    for(my $i=1;$i<=(${$hash{$_}}[2]-${$hash{$_}}[1])/$step-1;++$i){
        my ($stt,$end)=(($i-1)*$step+1+${$hash{$_}}[1],($i-1)*$step+$windows+${$hash{$_}}[1]);
        my ($c_nu,$methlev1)=&get(${$hash{$_}}[0],$stt,$end);
        next if $c_nu<5;
        print OUT "${$hash{$_}}[0]\t$stt\t$end\t$c_nu\t$methlev1\n";
    }
}

sub get{
    my ($chrom,$stt,$end)=@_;
    my ($methlev,$c_nu)=(0,0);
    for(my $i=$stt;$i<=$end;++$i){
        if(exists $meth_hash{"$chrom\t$i"}){
            $methlev+=$meth_hash{"$chrom\t$i"};
            $c_nu++;
        }
    }
    $methlev=$methlev/($c_nu+0.00001);
    return ($c_nu,$methlev);
}

sub usage{
    my $die=<<DIE;
    Usage:perl *.pl <Geno_len> <Windows size> <Step size> <Forw> <Rev> <OUT> 
    OUTPUT:
    <Chrom> <STT> <END> <C Number>  <Methylation Level>
DIE
}
