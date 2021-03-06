#!/usr/bin/perl -w
use strict;
my ($geno,$ge_pos)=@ARGV;
die usage() unless @ARGV==2;
open GENO,$geno or die "$!";
my @aa=<GENO>;
my $join=join('',@aa);
   @aa=split(/>/,$join);
shift @aa;
my %hash;
foreach(@aa){
    chomp;
    my ($chr,@seq)=split(/\n/);
    ($chr)=split(/\|/,$chr);
    $chr=~s/chr0/chr/;
    chomp @seq;
    my $seq=join('',@seq);
    $hash{$chr}=$seq;
}
undef @aa;

open POS,$ge_pos or die "$!";
my %hash_pos;
while(<POS>){
    next if /^#/;
    chomp;
    my ($chr,$ele,$stt,$end,$strand,$gene)=(split)[0,2,3,4,6,-1];
    $chr=~s/Chr/chr/;
    next if $ele!~/gene/;
    my $ge_anno;
    ($ge_anno,$gene)=$gene=~/Name=(.*);Alias=LOC\_(.*)/;
    next if !exists $hash{"$chr"};
    my $seq=substr($hash{"$chr"},$stt,$end-$stt+1);
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
    print "$chr\t$stt\t$end\t$gene\t$strand\t$ge_anno\t$cg_nu\t$chg_nu\t$c_nu\t$g_nu\t$cg_oe\t$chg_oe\n";
}


sub usage{
    my $die=<<DIE;
    perl *.pl <Genome sequence> <Gene position>
DIE
}
