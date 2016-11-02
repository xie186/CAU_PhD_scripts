#!/usr/bin/perl -w
use strict;
my ($geno,$gene,$prot)=@ARGV;
die usage() unless @ARGV==3;
open GENO,$geno or die "$!";
my @aa=<GENO>;
my $join=join('',@aa);
   @aa=split(/>/,$join);
shift @aa;
my %hash;
foreach(@aa){
    chomp;
    my ($chr,@seq)=split(/\n/);
    chomp @seq;
    my $seq=join('',@seq);
    $hash{$chr}=$seq;
}
undef @aa;

open PROT,$prot or die "$!";
while(<PROT>){
    chomp;
    my ($chr,$stt,$end,$gene,$strand,$type)=split;
    $hash{$gene}++;
}

open GE,$gene or die "$!";
while(<GE>){
    next if !/^\d/;
    chomp;
    my ($chr,$ele,$stt,$end,$strand,$name)=(split)[0,2,3,4,6,8];
    ($name)=(split(/=/,(split(/;/,$name))[0]))[1];
    $name=~s/_T\d+// if $name=~/GRMZM/;
    next if !exists $hash{$name};
    next if($ele=~/gene/ || $ele=~/chromosome/ || $ele=~/CDS/);
    my $seq=substr($hash{"chr$chr"},$stt-1,$end-$stt+1);
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
    print "$chr\t$ele\t$stt\t$end\t$cg_nu\t$chg_nu\t$len\t$c_nu\t$g_nu\t$cg_oe\t$chg_oe\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Genome sequence> <Gene GFF file> <Gene position [Prot]> 
DIE
}
