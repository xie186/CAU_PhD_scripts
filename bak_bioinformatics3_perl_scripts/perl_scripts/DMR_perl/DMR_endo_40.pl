#!/usr/bin/perl -w
use strict;
my ($region)=@ARGV;
die usage() unless @ARGV==1;
open REGION,$region or die "$!";
while(<REGION>){
    my ($chr1,$stt1,$end1,$c_nu1,$lev1)=split;
    next if ($c_nu1<5 || $lev1>60 ||$lev1<20);
    PATH:{
        my $aa=<REGION>;
        my ($chr2,$stt2,$end2,$c_nu2,$lev2)=split(/\t+/,$aa);
        next if ($c_nu2<5 || $lev2>60 ||$lev2<20);
        if($chr2 eq $chr1 && $stt2>=$stt1 && $stt2<=$end1){
            ($chr1,$stt1,$end1)=($chr2,$stt1,$end2);
            redo PATH;
        }else{
            print "$chr1\t$stt1\t$end1\n";
            ($chr1,$stt1,$end1)=($chr2,$stt2,$end2);
            redo PATH;
        }
    }
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Regions> 
DIE
}
