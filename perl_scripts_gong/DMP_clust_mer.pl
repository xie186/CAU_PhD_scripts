#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==2;
my ($clus, $out) = @ARGV;
open OUT,"+>$out" or die "$!";
open CLUS,"sort -k1,1 -k2,2n $clus|" or die "$!";
while(my $line=<CLUS>){
    my ($chr1,$stt,$end,$stt1,$end1)=split(/\s+/,$line);
    PATH:{
        $line = <CLUS>;
        if(!$line){
            print OUT "$chr1\t$stt1\t$end1\n";
        }else{
            my ($chr2,$stt,$end,$stt2,$end2) = split(/\s+/,$line);
            if($chr2 eq $chr1 &&  $stt2 <= $end1 + 1000){
                 $end1 = $end2;
                 redo PATH;
            }else{
                print OUT "$chr1\t$stt1\t$end1\n";
                ($chr1,$stt1,$end1) = ($chr2,$stt2,$end2);
                redo PATH;
           }
        }
    }
}

sub usage{
    my $die =<<DIE;
    perl *.pl <DMP cluster>  <OUT> 
DIE
}
