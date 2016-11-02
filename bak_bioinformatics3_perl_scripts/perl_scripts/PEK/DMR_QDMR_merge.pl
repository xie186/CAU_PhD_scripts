#!/usr/bin/perl -w
use strict;
my ($dmr,$out)=@ARGV;
die usage() unless @ARGV==2;
open DMR,"sort -k2,2n $dmr |" or die "$!";
open OUT,"+>$out" or die "$!"; 
while(my $line=<DMR>){
     
    my ($chr1,$stt1,$end1)=(split(/\s+/,$line))[2,3,4];
    PATH:{
        $line=<DMR>;
        if(!$line){
            print OUT "$chr1\t$stt1\t$end1\n";
        }else{
            my ($chr2,$stt2,$end2)=(split(/\s+/,$line))[2,3,4];
            if($stt2>=$stt1 && $stt2<=$end1){
                $end1=$end2;
                redo PATH;
            }else{
                print OUT "$chr1\t$stt1\t$end1\n";
                ($stt1,$end1)=($stt2,$end2);
                redo PATH;
           }
        }
    }
}

sub usage{
    my $die=<<DIE;
    perl *.pl <DMR candidate> <OUT>
DIE
}
