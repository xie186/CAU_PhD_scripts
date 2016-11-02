#!/usr/bin/perl -w
use strict;
my ($ge_pos)=@ARGV;

open POS,"sort -k1,1 -k2,2n -k3,3n $ge_pos |" or die "$!";
my %fiv;my %thr;
while(my $line=<POS>){
    my ($chr1,$stt1,$end1)=split(/\s+/,$line);
    PATH:{
        $line=<POS>;
        if(!$line){
            $fiv{"chr$chr1\t$stt1"}=$stt1;
            print "$chr1\t$stt1\t$end1\n";
        }else{
            my ($chr2,$stt2,$end2)=split(/\s+/,$line);
            if($chr2 eq $chr1 && $stt2>=$stt1 && $stt2<=$end1){
                $end1=$end2;
                redo PATH;
            }else{
                print "$chr1\t$stt1\t$end1\n";
                ($chr1,$stt1,$end1)=($chr2,$stt2,$end2);
                redo PATH;
           }
        }
    }
}
