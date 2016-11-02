#!/usr/bin/perl -w
use strict;
my ($tissue,$out)=@ARGV;
die usage() unless @ARGV==2;
open FIR,$tissue or die "$!";
open OUT,"+>$out" or die "$!";
while(<FIR>){
    next if /track/;
    chomp;
    my ($chr,$stt,$end,$strand,$blk,$exon)=(split(/\s+/,$_))[0,1,2,5,10,11];
    my ($block_size1,$block_size2)=split(/,/,$blk);
    my ($boun1,$boun2)=($stt+$block_size1+1,$end-$block_size2+1);
    print OUT "$chr\t$boun1\t$boun2\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Tissue1> <OUT>
DIE
}
