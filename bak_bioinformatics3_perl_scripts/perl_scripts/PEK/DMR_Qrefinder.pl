#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==6;
my ($dmr,$forw,$rev,$forw_mo,$rev_mo,$out)=@ARGV;
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

#################MO_17###############
open MOF,$forw_mo or die "$!";
my %meth_mo;
while(<MOF>){
    chomp;
    my ($chr,$stt,$end,$depth,$lev)=split;
    next if $depth<3;
    $meth_mo{"$chr\t$stt"}=$lev;
}

open MOR,$rev_mo or die "$!";
while(<MOR>){
    chomp;
    my ($chr,$stt,$end,$depth,$lev)=split;
    next if $depth<3;
    $meth_mo{"$chr\t$stt"}=$lev;
}

open DMR,$dmr or die "$!";
open OUT,"+>$out" or die "$!";
while(<DMR>){
    chomp;
    my ($chrom,$stt,$end)=split;
    my ($c_b73,$methlev_b73,$c_mo,$methlev_mo)=&get($chrom,$stt,$end);
    print OUT "$chrom\t$stt\t$end\t$c_b73\t$methlev_b73\t$c_mo\t$methlev_mo\n";
}

sub get{
    my ($chrom,$stt,$end)=@_;
    my ($c_b73,$methlev_b,$c_mo,$methlev_mo)=(0,0,0,0);
    for(my $i=$stt;$i<=$end;++$i){
        if(exists $meth_hash{"$chrom\t$i"}){
            $methlev_b+=$meth_hash{"$chrom\t$i"};
            $c_b73++;
        }
        if(exists $meth_mo{"$chrom\t$i"}){
            $methlev_mo+=$meth_mo{"$chrom\t$i"};
            $c_mo++;
        }
    }
    $methlev_b=$methlev_b/($c_b73+0.0000001);
    $methlev_mo=$methlev_mo/($c_mo+0.0000001);
    return ($c_b73,$methlev_b,$c_mo,$methlev_mo);
}

sub usage{
    my $die=<<DIE;

    Usage:perl *.pl <DMR> <Forw_B73> <Rev B73> <Forw mo17> <Rev_mo17> <OUT1>
    OUTPUT:
    <Chrom> <STT> <END> <T1_meth_nu> <T1-unmeth_nu> <T1_methlev> <T2_meth_nu> <T2_unmeth_nu> <T2_methlev>

DIE
}
