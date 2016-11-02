#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==2;
my ($ge_te,$rpkm)=@ARGV;

open RPKM,$rpkm or die "$!";
my %hash_rpkm;
while(<RPKM>){
    chomp;
    my ($gene,$rpkm_val)=(split)[0,-1];
     $hash_rpkm{$gene}=$rpkm_val;
}

open POS,$ge_te or die "$!";
while(<POS>){
    chomp;
    next if !/^\d/;
    my ($chr,$stt,$end,$gene,$strand,$type,$teOr)=split;
    my $tem_rpkm=0;
       $tem_rpkm=$hash_rpkm{$gene} if exists $hash_rpkm{$gene};
    print "$_\t$tem_rpkm\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Gene position with TE insertion information> <RPKM value of genes> 
DIE
}
