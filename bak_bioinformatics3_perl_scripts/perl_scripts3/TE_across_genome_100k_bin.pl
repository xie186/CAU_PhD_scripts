#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==4;
my ($geno_len,$te_type,$gff,$chrom,$out)=@ARGV;
#die "$out exists!!!\n" if -e $out;

open TE,$te_type or die "$!";
while(<TE>){
    chomp;
    my ($chr,$stt,$end,$)
}
open GENO,$geno_len or die "$!";
my %geno_len;
while(<GENO>){
    chomp;
    my ($chr,$len)=split;
    $geno_len{$chr}=$len;
}

open TE,$gff or die "$!";
my %hash;
while(<TE>){
    next if /^#/;
    chomp;
    my ($chr,$stt,$end)=(split(/\s+/,$_));
    next if $end-$stt+1 > 1000;
    $chr = "chr".$chr;
    next if $chr ne "$chrom";
    my $pos=int (($stt+$end)/2);
    $hash{$pos}++;
}

my $num=int $geno_len{$chrom}/100000;
open OUT,"+>$out" or die "$!";
for(my $i=0;$i<=$num;++$i){
     my $TE_nu=0;
    for(my $j=$i*100000;$j<=$i*100000+100000;++$j){
        if(exists $hash{"$j"}){
             $TE_nu++;
        }
    }
    my $win_stt=$i*100000;
    print OUT "$win_stt\t$TE_nu\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Genome> <TE GFF> <Chromosome Number> <OUT>
    <windows> <TE number>
DIE
}
