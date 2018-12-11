#!/usr/bin/perl -w
use strict;

my ($chr,$stt,$end,$geno)=@ARGV;

open GENO,$geno or die;
my @aa=<GENO>;
my $mid=join '',@aa;
@aa=split(/>/,$mid);
my %hash;
foreach(@aa){
    my @tem=split(/\n+/,$_);
    my $key=shift @tem;
    chomp @tem;
    my $seq=join('',@tem);
    $hash{$key}=$seq;
}

my $resid=int (($end-$stt+1)/50);
for(my $i=0;$i<=$resid-6;++$i){
    my $region=substr($hash{$chr},$stt+$i*50,300);
    my $c=$region=~s/C/C/g;
    my $g=$region=~s/G/G/g;
    my $cg=($c+$g)/300;
    printf ("%d\t%f\n",$stt+$i*50,$cg);
}
