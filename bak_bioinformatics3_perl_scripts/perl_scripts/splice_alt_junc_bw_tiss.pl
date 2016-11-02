#!/usr/bin/perl -w
use strict;
my ($tissue1,$tissue2,$endo,$sd)=@ARGV;
die usage() unless @ARGV==4;
open FIR,$tissue1 or die "$!";
my %hash_fir;<FIR>;
while(<FIR>){
    chomp;
    my ($chr,$stt,$end,$strand,$blk,$exon)=(split(/\s+/,$_))[0,1,2,5,10,11];
    my ($block_size1,$block_size2)=split(/,/,$blk);
    my ($boun1,$boun2)=($stt+$block_size1,$end-$block_size2);
    $hash_fir{"$chr\t$boun1\t$boun2"}=$_;
}

open SEC,$tissue2 or die "$!";
my %hash_sec;
open ENDO,"+>$endo" or die "$!";
<SEC>;
while(<SEC>){
    chomp;
    my ($chr,$stt,$end,$strand,$blk,$exon)=(split(/\s+/,$_))[0,1,2,5,10,11];
    my ($block_size1,$block_size2)=split(/,/,$blk);
    my ($boun1,$boun2)=($stt+$block_size1,$end-$block_size2);
    $hash_sec{"$chr\t$boun1\t$boun2"}=$_;
    print ENDO "$_\n" if !exists $hash_fir{"$chr\t$boun1\t$boun2"};
}

open SD,"+>$sd" or die "$!";
foreach(keys %hash_fir){
    if(exists $hash_sec{$_}){
#        print SD "$hash_fir{$_}\n";
        delete $hash_fir{$_};
        delete $hash_sec{$_};
    }else{
        print SD "$hash_fir{$_}\n";
    }
}
sub usage{
    my $die=<<DIE;
    perl *.pl <Tissue1> <Tissue2> <Endo alt> <Seedlings alt>
DIE
}
