#!/usr/bin/perl -w
use strict;
my ($pileup,$geno,$out)=@ARGV;

die usage() unless @ARGV==3;

open OUT,"+>$out" or die "$!";
open GENO,$geno or die "$!";
my @seq=<GENO>;
my $chr=shift @seq;
my $seq=join'',@seq;
   @seq=();

my $c=$seq=~s/C/C/g;
my $cg=$seq=~s/CG/CG/g;
my $chg1=$seq=~s/CAG/CAG/g;
my $chg2=$seq=~s/CTG/CTG/g;
my $chg3=$seq=~s/CCG/CCG/g;

my $chg=$chg1+$chg2+$chg3;

my %hash;
open PILEUP,$pileup or die "$!";
while(<PILEUP>){
    chomp;
    my ($pos,$base)=(split(/\s+/,$_))[1,2];
    if ($base eq "C"){
        &judge($pos,$base);
    }
}
my $chh=$seq=~s/C[ATC][ATC]/C[ATC][ATC]/g;
print OUT "genome\nC\t$c\nCpG\t$cg\nCHG\t$chg\nCHH\t$chh\n";

foreach(keys %hash){
     print OUT "Bismark\t$_\t$hash{$_}\n";
}

sub judge{
    my ($pos,$base)=@_;
    $hash{"C"}++;
    my $context=substr($seq,$pos-1,3);
    if($context=~/^CG/){
        $hash{"CpG"}++; 
    }elsif($context=~/^C[ATC]G/){
        $hash{"CHG"}++;
    }elsif($context=~/^C[ATC][ATC]/){
        $hash{"CHH"}++;
    }else{
        next;
    }
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Bismrak_pileup> <Genome> <OUT>
DIE
}
