#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==6;
my ($sd,$em,$en,$pos,$prefer,$cut)=@ARGV;

open SD,$sd or die "$!";
my %hash_sd;
while(<SD>){
    chomp;
    my ($gene,$rpkm)=(split)[0,-1];
    $hash_sd{$gene}=$rpkm;
}

open EM,$em or die "$!";
my %hash_em;
while(<EM>){
    chomp;
    my ($gene,$rpkm)=(split)[0,-1];
    $hash_em{$gene}=$rpkm;
}

open EN,$en or die "$!";
my %hash_en;
while(<EN>){
    chomp;
    my ($gene,$rpkm)=(split)[0,-1];
    $hash_en{$gene}=$rpkm;
}

open POS,$pos or die "$!";
while(<POS>){
    chomp;
    my ($chr,$stt,$end,$gene,$strand,$type,$cpg_oe)=(split)[0,1,2,3,4,5,11];
    next if (/^Pt/ || /^Mt/ || /^UNKNOWN/);
    my ($rpkm_sd,$rpkm_em,$rpkm_en)=(0,0,0);
    $rpkm_sd = $hash_sd{$gene} if exists $hash_sd{$gene};
    $rpkm_em = $hash_em{$gene} if exists $hash_em{$gene};
    $rpkm_en = $hash_en{$gene} if exists $hash_en{$gene};
    if($prefer eq "sd"){
        print "$chr\t$stt\t$end\t$stt\t$gene\t$cpg_oe\t$rpkm_sd\t$rpkm_em\t$rpkm_en\n" if($rpkm_sd/($rpkm_em+0.0000001)>=$cut && $rpkm_sd/($rpkm_en+0.0000001)>=$cut && $rpkm_sd >= 1);
    }elsif($prefer eq "em"){
        print "$chr\t$stt\t$end\t$stt\t$gene\t$cpg_oe\t$rpkm_sd\t$rpkm_em\t$rpkm_en\n" if($rpkm_em/($rpkm_sd+0.0000001)>=$cut && $rpkm_em/($rpkm_en+0.0000001)>=$cut && $rpkm_em >= 1);
    }elsif($prefer eq "en"){
        print "$chr\t$stt\t$end\t$stt\t$gene\t$cpg_oe\t$rpkm_sd\t$rpkm_em\t$rpkm_en\n" if($rpkm_en/($rpkm_sd+0.0000001)>=$cut && $rpkm_en/($rpkm_em+0.0000001)>=$cut && $rpkm_en >= 1);
    }
}

sub usage{
    my $die=<<DIE;
    perl *.pl <SD rpkm> <EM RPKM> <EN RPKM> <Gene position> <Tis [sd][em][en]> <FC cutoff>
DIE
}
