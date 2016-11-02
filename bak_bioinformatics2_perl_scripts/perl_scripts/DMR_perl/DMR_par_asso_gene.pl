#!/usr/bin/perl -w
use strict;
my ($rpkm,$dmr,$genepos,$out)=@ARGV;
die usage() unless @ARGV==4;
open RPKM,$rpkm or die "$!";
my %rpkm;
while(<RPKM>){
    chomp;
    my ($gene,$rpkm)=(split)[0,-1];
    $rpkm{$gene}=$rpkm;
}
open DMR,$dmr or die "$!";
my %dmr_hash;
while(<DMR>){
    my ($chr,$stt,$end,$b73,$mo17)=(split)[0,1,2,4,6];
    my $mid=(int ($end+$stt)/2);
    @{$dmr_hash{"$chr\t$mid"}}=($stt,$end,$b73,$mo17);
}

open OUT,"+>$out" or die "$!";
open POS,$genepos or die "$!";
while(<POS>){
    chomp;
    my ($chr,$stt,$end,$gene)=split;
        $chr="chr".$chr;
    next if !exists $rpkm{$gene};
    for(my $i=$stt-2000;$i<=$end+2000;++$i){
        if(exists $dmr_hash{"$chr\t$i"}){
            my ($dmr_stt,$dmr_end,$b73,$mo17)=@{$dmr_hash{"$chr\t$i"}};
            my $rpkm=$rpkm{$gene} if exists $rpkm{$gene};
            print OUT "$_\t$dmr_stt\t$dmr_end\t$b73\t$mo17\t$rpkm\n";
        }
    }
}

sub usage{
    my $die=<<DIE;
    perl *.pl <RPKM or gene imp infor> <DMR> <gene position> <OUT>
DIE
}
