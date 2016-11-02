#!/usr/bin/perl -w
use strict;
my ($dmr,$genepos,$out)=@ARGV;
die usage() unless @ARGV==3;
open DMR,$dmr or die "$!";
my %dmr_hash;
while(<DMR>){
    my ($chr,$stt,$end,$b73,$mo17)=(split)[0,1,2,4,6];
    my $mid=(int ($end+$stt)/2);
#    my ($min,$max)=sort{$a<=>$b}($b73,$mo17);
#    next if ($min>30 ||$max<70);
    @{$dmr_hash{"$chr\t$mid"}}=($stt,$end,$b73,$mo17);
}

open OUT,"+>$out" or die "$!";
open POS,$genepos or die "$!";
while(<POS>){
    chomp;
    my ($chr,$stt,$end)=split;
    for(my $i=$stt-2000;$i<=$end+2000;++$i){
        if(exists $dmr_hash{"$chr\t$i"}){
            my ($dmr_stt,$dmr_end,$b73,$mo17)=@{$dmr_hash{"$chr\t$i"}};
            print OUT "$_\t$dmr_stt\t$dmr_end\t$b73\t$mo17\n";
        }
    }
}

sub usage{
    my $die=<<DIE;
    perl *.pl <DMR> <gene position> <OUT>
DIE
}
