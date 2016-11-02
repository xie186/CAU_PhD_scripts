#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==2;
my ($geno,$gff)=@ARGV;
open GENO,$geno or die "$!";
my @aa=<GENO>;
my $join=join('',@aa);
$join=~s/>//;
   @aa=split(/>/,$join);
my %hash;
foreach(@aa){
    chomp;
    next if !/^\d/;
    my ($chr,@seq)=split(/\n/);
    ($chr)=split(/\s+/,$chr);
    my $seq=join('',@seq);
    $chr="chr".$chr;
    $hash{$chr}=$seq;
}

open GFF,$gff or die "$!";
while(<GFF>){
    chomp;
    my ($chr,$ele,$stt,$end,$name)=(split)[0,2,3,4,-1];
    next if ($name!~/Note/ || $chr!~/Chr\d/);
    my ($type)=$name=~/Note=(.*);Name=/;
    $chr=~s/Chr/chr/;
    my $seq=substr($hash{$chr},$stt-1,$end-$stt+1);
    my $c_nu=$seq=~s/C/C/g;
    my $g_nu=$seq=~s/G/G/g;
    my $cg_nu=0;
    my $chg_nu=0;
        $cg_nu=$seq=~s/CG/CG/g;
        $chg_nu+=$seq=~s/CAG/CAG/g;
        $chg_nu+=$seq=~s/CTG/CTG/g;
        $chg_nu+=$seq=~s/CCG/CCG/g;
    my $len=length $seq;
    my $cg_oe=0;
    my $chg_oe=0;
       $cg_nu=0 if !$cg_nu;
       $chg_nu=0 if !$chg_nu;
       $c_nu=0 if !$c_nu;
       $g_nu=0 if !$g_nu;
       $cg_oe=$cg_nu*$len/$c_nu/$g_nu if $cg_nu>0;
       $chg_oe=$chg_nu*$len/$c_nu/$g_nu if $chg_nu>0;
    print "$chr\t$stt\t$end\t$type\t$cg_nu\t$chg_nu\t$c_nu\t$g_nu\t$cg_oe\t$chg_oe\n";
}


sub usage{
    my $die=<<DIE;
    perl *.pl <Genome sequence> <Gene position>
DIE
}
