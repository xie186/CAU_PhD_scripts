#!/usr/bin/perl -w
use strict;
my ($dmr,$out)=@ARGV;
die usage() unless @ARGV==2;
open DMR,"sort -k1,1 -k2,2n $dmr |" or die "$!";
open OUT,"+>$out" or die "$!"; 
<DMR>;
while(my $line=<DMR>){
#    next if $line!~/\d/;
    my ($chr1,$stt1,$end1)=(split(/\s+/,$line))[0,1,2];
    PATH:{
        $line=<DMR>;
        if(!$line){
            print OUT "$chr1\t$stt1\t$end1\n";
        }else{
            my ($chr2,$stt2,$end2)=(split(/\s+/,$line))[0,1,2];
            if($chr2 eq $chr1 && $stt2>=$stt1 && $stt2<=$end1){
                $end1=$end2;
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
    perl *.pl <DMR candidate> <OUT>
DIE
}
