#!/usr/bin/perl -w
use strict;
my ($geno,$dmr)=@ARGV;
die usage() unless @ARGV;
open GENO,$geno or die "$!";
my $chr=<GENO>;
$chr=~s/>//;
my $seq;
chomp $chr;
while(<GENO>){
    chomp;
    $seq.=$_;
}
my %hash;
   $hash{$chr}=$seq;
my $geno_c=$seq=~s/C/C/g;
my $geno_cg=$seq=~s/CG/CG/g;
my $geno_len=length $seq;
   ($geno_c,$geno_cg)=($geno_c/$geno_len,$geno_cg/$geno_len);
open DMR,$dmr or die "$!";
while(<DMR>){
    chomp;
    my ($chrom,$stt,$end)=split;
    my $sub=substr($hash{$chrom},$stt-1,$end-$stt+1);
    my $c=$sub=~s/C/C/g;
       $sub=substr($hash{$chrom},$stt-1,$end-$stt+2);
    my $cg=$sub=~s/CG/CG/g;
       ($c,$cg)=($c/($end-$stt+1),$cg/($end-$stt+1));
    
    print "$chrom\t$stt\t$end\t$c\t$cg\t$geno_c\t$geno_cg\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Geno> <DMR>
DIE
}
