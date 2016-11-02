#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==4;
my ($geno_len,$gene,$chrom,$out)=@ARGV;
die "$out exists!!!\n" if -e $out;

open LEN,$geno_len or die "$!";
my $length;
while(<LEN>){
    chomp;
    my ($chr,$len)=split;
    $length=$len if $chrom eq $chr;
}
open GENE,$gene or die "$!";
my %hash;
while(<GENE>){
    chomp;
    my ($chr,$stt,$end)=(split(/\s+/,$_))[0,1,2];
    $chr="chr".$chr;
    next if $chr ne "$chrom";
    my $pos=int ($stt+$end)/2;
    $hash{"$chrom\t$pos"}++;
}

my $num=int $length/50000;
open OUT,"+>$out" or die "$!";
for(my $i=0;$i<=$num;++$i){
     my $TE_nu=0;
    for(my $j=$i*50000;$j<=$i*50000+50000;++$j){
        if(exists $hash{"$chrom\t$j"}){
             $TE_nu++;
        }
    }
    my $win_stt=$i*50000;
    print OUT "$chrom\t$win_stt\t$TE_nu\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Geno length> <CGI pos> <Chrom> <OUT>
    <windows> <TE number>
DIE
}
