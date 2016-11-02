#!/usr/bin/perl -w
use strict;
my ($dmr,$genepos,$out)=@ARGV;
die usage() unless @ARGV==3;
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
    my ($chr,$stt,$end)=split;
       $chr="chr".$chr;
    for(my $i=$stt;$i<=$end;++$i){
        if(exists $dmr_hash{"$chr\t$i"}){
            my ($dmr_stt,$dmr_end,$seed,$em,$endo)=@{$dmr_hash{"$chr\t$i"}};
            print OUT "$_\t$dmr_stt\t$dmr_end\t$seed\t$em\t$endo\n";
        }
    }
}

sub usage{
    my $die=<<DIE;
    perl *.pl <DMR> <gene position> <OUT>
DIE
}
