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
    my ($chr,$ele,$stt,$end,$gene)=(split)[0,2,3,4,8];
        $chr="chr".$chr;
    for(my $i=$stt;$i<=$end;++$i){
        if(exists $dmr_hash{"$chr\t$i"}){
            my ($dmr_stt,$dmr_end,$b73,$mo17)=@{$dmr_hash{"$chr\t$i"}};
            my $rpkm=0;
               $rpkm=$rpkm{$gene} if exists $rpkm{$gene};
            print OUT "$chr\t$stt\t$end\t$gene\t$ele\t$dmr_stt\t$dmr_end\t$b73\t$mo17\t$rpkm\n";
        }
    }
}

sub usage{
    my $die=<<DIE;
    perl *.pl <RPKM> <DMR> <GFF file> <OUT>
DIE
}
