#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==4;
my ($syn,$ge_pos,$rpkm,$out)=@ARGV;
open SYN,$syn or die "$!";
my %hash_syn;
while(<SYN>){
    chomp;
    my ($syn1,$syn2) = split;
    $hash_syn{$syn1} ++;
    $hash_syn{$syn2} ++;
}
open RPKM,$rpkm or die "$!";
my %hash;
while(<RPKM>){
    chomp;
    my ($gene,$rpkm)=(split)[0,-4];
    $hash{$gene}=$rpkm;
}

open POS,$ge_pos or die "$!";
open OUT2,"+>$out";
while(<POS>){
    chomp;
    my ($chr,$stt,$end,$gene,$strand,$type)=(split)[0,1,2,3,4,5];
    next if !exists $hash_syn{$gene};
    next if !/^\d/;
#    print "$chr,$stt,$end,$gene,$strand\n";
    my $tem_rpkm=0;
       $tem_rpkm=$hash{$gene} if exists $hash{$gene};
    print OUT2 "$chr\t$stt\t$end\t$gene\t$strand\t$type\t$tem_rpkm\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Syntenic genes> <Gene FGS postion> <FPKM> <out>
DIE
}
