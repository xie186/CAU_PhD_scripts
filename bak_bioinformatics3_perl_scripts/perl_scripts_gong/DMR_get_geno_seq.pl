#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==2;
my ($geno,$dmr)=@ARGV;
open GENO,$geno or die "$!";
my @aa=<GENO>;
my $join=join('',@aa);
   $join=~s/>//;
   @aa=split(/>/,$join);
my %hash;
my $chr_nu=@aa;
for(my $i=0;$i<=$chr_nu;++$i){
    my $tem_seq=shift @aa;
    next if !$tem_seq;
    my ($chr,@seq)=split(/\n/,$tem_seq);
    chomp @seq;
    $tem_seq=join'',@seq;
    $hash{$chr}=$tem_seq;
}

open DMR,$dmr or die "$!";
while(<DMR>){
    chomp;
    my ($chr,$stt,$end) = split;
    my $seq = substr($hash{$chr},$stt-51,$end-$stt+1+100);
    print ">DMR_$chr\_$stt\_$end\n$seq\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl  <Genome> <DMR>
    To get sequence 50 bp upstream, 50 downstream of DMR.
DIE
}
