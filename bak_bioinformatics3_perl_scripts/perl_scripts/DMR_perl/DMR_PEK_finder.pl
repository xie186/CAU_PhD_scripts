#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==6;
my ($geno_len,$windows,$step,$forw,$rev,$out)=@ARGV;

open LEN,$geno_len or die "$!";
my %hash;
while(<LEN>){
    chomp;
    next if (/^chr0/ || /^chrMt/ || /^chrPT/)
    my ($chr,$len)=split;
    $hash{$chr}=$len;
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
foreach my $chrom(sort keys %hash){
    for(my $i=1;$i<=$hash{$chrom}/$step-1;++$i){
        my ($stt,$end)=(($i-1)*$step+1,($i-1)*$step+$windows);
        my ($c_nu,$methlev1)=&get($chrom,$stt,$end);
        next if $c_nu<5;
        print OUT "$chrom\t$stt\t$end\t$c_nu\t$methlev1\n";
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
