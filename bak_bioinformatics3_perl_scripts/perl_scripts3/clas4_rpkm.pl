#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==6;
my ($clas4,$rpkm,$out1,$out2,$out3,$out4)=@ARGV;
open RPKM,$rpkm or die "$!";
my %hash;
while(<RPKM>){
    chomp;
    my ($gene,$rpkm)=(split)[0,-1];
    $hash{$gene}=$rpkm;
}

open POS,$clas4 or die "$!";
open OUT1,"+>$out1";
open OUT2,"+>$out2";
open OUT3,"+>$out3";
open OUT4,"+>$out4";
while(<POS>){
    chomp;
    my ($chr,$stt,$end,$gene,$strand,$type,$class)=split;
    my $tem_rpkm=0;
       $tem_rpkm=$hash{$gene} if exists $hash{$gene};
    if(/LCTE/){
        print OUT1 "$chr\t$stt\t$end\t$gene\t$strand\t$type\t$class\t$tem_rpkm\n";
    }elsif(/LCNT/){
        print OUT2 "$chr\t$stt\t$end\t$gene\t$strand\t$type\t$class\t$tem_rpkm\n";
    }elsif(/HCTE/){
        print OUT3 "$chr\t$stt\t$end\t$gene\t$strand\t$type\t$class\t$tem_rpkm\n";
    }elsif(/HCNT/){
        print OUT4 "$chr\t$stt\t$end\t$gene\t$strand\t$type\t$class\t$tem_rpkm\n";
    }
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Class4> <rpkm> <out LCTE> <out LCNT> <out HCTE> <out HCNT>
DIE
}
