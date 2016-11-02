#!/usr/bin/perl -w
use strict;
my ($rpkm,$dmr,$genepos,$out)=@ARGV;
die usage() unless @ARGV==4;
open RPKM,$rpkm or die "$!";
my %rpkm;
while(<RPKM>){
    chomp;
    my ($gene,$rpkm)=(split)[0,-1];
    $rpkm{$gene}++;
}
open DMR,$dmr or die "$!";
my %dmr_hash;
while(<DMR>){
    my ($chr,$stt,$end,$mb_b73,$mb_mo17,$bm_b73,$bm_mo17)=(split)[0,1,2,4,6,8,10];
    my $mid=int (($end+$stt)/2);
    @{$dmr_hash{"$chr\t$mid"}}=($stt,$end,$mb_b73,$mb_mo17,$bm_b73,$bm_mo17);
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
            print "$_\n";
            my ($dmr_stt,$dmr_end,$mb_b73,$mb_mo17,$bm_b73,$bm_mo17)=@{$dmr_hash{"$chr\t$i"}};
            my $rpkm=$rpkm{$gene} if exists $rpkm{$gene};
            print OUT "$_\t$dmr_stt\t$dmr_end\t$mb_b73\t$mb_mo17\t$bm_b73\t$bm_mo17\n";
        }
    }
}

sub usage{
    my $die=<<DIE;
    perl *.pl <gene imp infor> <DMR> <gene position> <OUT>
DIE
}
