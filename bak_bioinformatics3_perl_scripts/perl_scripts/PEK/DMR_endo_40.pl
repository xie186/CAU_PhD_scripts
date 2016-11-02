#!/usr/bin/perl -w
use strict;
my ($region,$eadge1,$eadge2)=@ARGV;
die usage() unless @ARGV==3;
open REGION,$region or die "$!";
while(<REGION>){
    my ($chr1,$stt1,$end1,$c_nu1,$lev1)=split;
    next if ($c_nu1<5 || $lev1>$eadge2 ||$lev1<$eadge1);
    my $i=0;
    PATH:{
        my $aa=<REGION>;
        next if !$aa;
        my ($chr2,$stt2,$end2,$c_nu2,$lev2)=split(/\t+/,$aa);
        next if ($c_nu2<5 || $lev2>=$eadge2 ||$lev2<=$eadge1);
        if($chr2 eq $chr1 && $stt2>=$stt1 && $stt2<=$end1+1){
            ($chr1,$stt1,$end1)=($chr2,$stt1,$end2);
            ++$i;
            redo PATH;
        }else{
            print "$chr1\t$stt1\t$end1\t$i\n";
            $i=0;
            ($chr1,$stt1,$end1)=($chr2,$stt2,$end2);
            redo PATH;
        }
    }
}
sub usage{
    my $die=<<DIE;
    perl *.pl <Regions> <Eadge1 small> <Eadge2 Large>
DIE
}
