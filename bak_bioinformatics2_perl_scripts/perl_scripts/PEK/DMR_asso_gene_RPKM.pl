#!/usr/bin/perl -w
use strict;
my ($rpkm,$dmr,$genepos,$out)=@ARGV;
die usage() unless @ARGV==4;

open POS,$genepos or die "$!";
my %rpkm;
while(<POS>){
    chomp;
    my ($chr,$stt,$end,$gene,$strand)=split;
    @{$rpkm{$gene}}=(0,0);
}

open RPKM,$rpkm or die "$!";
while(<RPKM>){
    chomp;
    my ($gene,$rpkm_sd,$rpkm_en)=split;
    @{$rpkm{$gene}}=($rpkm_sd,$rpkm_en);
}

open DMR,$dmr or die "$!";
my %dmr_hash;
while(<DMR>){
    my ($chr,$stt,$end,$seed,$em,$endo)=(split)[0,1,2,5,8,11];
    my $mid=(int ($end+$stt)/2);
    @{$dmr_hash{"$chr\t$mid"}}=($stt,$end,$seed,$em,$endo);
}

open OUT,"+>$out" or die "$!";
open POS,$genepos or die "$!";
while(<POS>){
    chomp;
    my ($chr,$stt,$end,$gene)=split;
       $chr="chr".$chr;
    for(my $i=$stt;$i<=$end;++$i){
        if(exists $dmr_hash{"$chr\t$i"}){
            my ($dmr_stt,$dmr_end,$seed,$em,$endo)=@{$dmr_hash{"$chr\t$i"}};
            my ($rpkm_sd,$rpkm_en)=@{$rpkm{$gene}};
            print OUT "$gene\t$rpkm_sd\t$rpkm_en\t$seed\t$endo\n";
        }
    }
}

sub usage{
    my $die=<<DIE;
    perl *.pl <RPKM> <DMR> <gene position> <OUT>
DIE
}
