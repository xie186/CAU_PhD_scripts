#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==2;
my ($geno,$version1)=@ARGV;

open GENO,$geno or die "$!";
my @tem=<GENO>;
my $join=join '',@tem;
   @tem=split(/>/,$join);
my %geno;
foreach(@tem){
    my @seq=split(/\n/,$_);
    my $chr=shift @seq;
    my $sequ=join '',@seq;
    $geno{$chr}=$sequ if ($chr);
}

open IES,$version1 or die "$!";
while(<IES>){
    chomp; 
    my($chr,$stt,$end)=(split(/\s+/,$_))[1,2,3];
    $chr="chr".$chr;
    my $seq=substr($geno{$chr},$stt-1,$end-$stt+1);
    print ">IES_$chr","_$stt","_$end\n$seq\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Genome> <Version1 IES pos> >out
DIE
}
