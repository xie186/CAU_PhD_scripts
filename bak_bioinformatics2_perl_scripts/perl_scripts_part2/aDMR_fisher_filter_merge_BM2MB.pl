#!/usr/bin/perl -w
use strict;
my ($dmr,$out)=@ARGV;
die usage() unless @ARGV==2;
open OUT,"+>$out" or die "$!";
open DMR,"sort -k1,1 -k2,2n $dmr|" or die "$!";
while(my $line=<DMR>){
    my ($chr1,$stt1,$end1,$lev_bmb1,$lev_bmm1)=(split(/\s+/,$line))[0,1,2,6,10];
    PATH:{
        $line=<DMR>;
        if(!$line){
            print OUT "$chr1\t$stt1\t$end1\n";
        }else{
            my ($chr2,$stt2,$end2,$lev_bmb2,$lev_bmm2)=(split(/\s+/,$line))[0,1,2,6,10];
            if($chr2 eq $chr1 && $stt2>=$stt1 && $stt2<=$end1){
#                 print "ooa\n$chr1,$stt1,$end1,$lev_bmb1,$lev_bmm1,$lev_mbb1,$lev_mbm1\n$chr2,$stt2,$end2,$lev_bmb2,$lev_bmm2,$lev_mbb2,$lev_mbm2\n" if (($lev_bmb1 > $lev_bmm1 && $lev_bmb2 < $lev_bmm2) || ($lev_bmb1 < $lev_bmm1 && $lev_bmb2 > $lev_bmm2));
                 if (($lev_bmb1 > $lev_bmm1 && $lev_bmb2 < $lev_bmm2) || ($lev_bmb1 < $lev_bmm1 && $lev_bmb2 > $lev_bmm2)){
                     $line = <DMR>;
                     last if !$line;
                     ($chr1,$stt1,$end1,$lev_bmb1,$lev_bmm1)=(split(/\s+/,$line))[0,1,2,6,10]; 
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
    This script has been hodyfied to avoid the situation that overlapped windows has opposite methylation patterns.

DIE
}
