#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==4;
my ($dmr,$forw,$rev,$out)=@ARGV;
open FORW,$forw or die "$!";
my %meth_hash;
while(<FORW>){
    chomp;
    my ($chr,$stt,$end,$depth,$lev)=split;
    next if $depth<3;
    $meth_hash{"$chr\t$stt"}=$lev;
}

open REV,$rev or die "$!";
while(<REV>){
    chomp;
    my ($chr,$stt,$end,$depth,$lev)=split;
    next if $depth<3;
    $meth_hash{"$chr\t$stt"}=$lev;
}

open DMR,$dmr or die "$!";
open OUT,"+>$out" or die "$!";
while(<DMR>){
    chomp;
    my ($chrom,$stt,$end)=split;
    my ($c_b73,$methlev_b73)=&get($chrom,$stt,$end);
    print OUT "$chrom\t$stt\t$end\t$c_b73\t$methlev_b73\n";
}

sub get{
    my ($chrom,$stt,$end)=@_;
    my ($c_b73,$methlev_b)=(0,0,0,0);
    for(my $i=$stt;$i<=$end;++$i){
        if(exists $meth_hash{"$chrom\t$i"}){
            $methlev_b+=$meth_hash{"$chrom\t$i"};
            $c_b73++;
        }
    }
    $methlev_b=$methlev_b/($c_b73+0.0000001);
    return ($c_b73,$methlev_b);
}

sub usage{
    my $die=<<DIE;
    Usage:perl *.pl <DMR> <Forw_B73> <Rev B73>  <OUT1>
    OUTPUT:
    <Chrom> <STT> <END> <T1_meth_nu> <T1-meth_lev

DIE
}
