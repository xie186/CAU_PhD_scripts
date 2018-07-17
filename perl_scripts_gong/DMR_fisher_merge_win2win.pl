#!/usr/bin/perl -w
use strict;
my ($dmr,$out)=@ARGV;
die usage() unless @ARGV==2;
open OUT,"+>$out" or die "$!";
open DMR,"sort -k1,1 -k2,2n $dmr|" or die "$!";
while(my $line=<DMR>){
    #chr1    201     300     28      198     180     0.523809523809524       28      375     105     0.78125      1.98960979663747e-15    2.24535499604349e-12
    my ($chr1,$stt1,$end1,$lev_bmb1,$lev_bmm1)=(split(/\s+/,$line))[0,1,2,6,10];
    PATH:{
        $line=<DMR>;
        if(!$line){
            print OUT "$chr1\t$stt1\t$end1\n";
        }else{
            my ($chr2,$stt2,$end2,$lev_bmb2,$lev_bmm2)=(split(/\s+/,$line))[0,1,2,6,10];
            if($chr2 eq $chr1 && $stt2>=$stt1 && $stt2<=$end1){
                 if (($lev_bmb1 > $lev_bmm1 && $lev_bmb2 < $lev_bmm2) || ($lev_bmb1 < $lev_bmm1 && $lev_bmb2 > $lev_bmm2)){
                     $line = <DMR>;
                     last if !$line;
                     ($chr1,$stt1,$end1,$lev_bmb1,$lev_bmm1)=(split(/\s+/,$line))[0,1,2,6,10,14,18]; 
                 }else{
                     $end1=$end2;
                 }
                 redo PATH;
            }else{
                print OUT "$chr1\t$stt1\t$end1\n";
                ($chr1,$stt1,$end1)=($chr2,$stt2,$end2);
                redo PATH;
           }
        }
    }
}

sub usage{
    my $die=<<DIE;

    perl *.pl <DMR> <OUT> 
    This script has been modyfied to avoid the situation that overlapped windows has opposite methylation patterns.

DIE
}
