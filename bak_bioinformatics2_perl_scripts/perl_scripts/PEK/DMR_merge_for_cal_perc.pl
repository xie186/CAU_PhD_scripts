#!/usr/bin/perl -w
use strict;
my ($dmr,$out)=@ARGV;
die usage() unless @ARGV==2;
open OUT,"+>$out" or die "$!";
open DMR,$dmr or die "$!";
while(my $line=<DMR>){
    my ($chr1,$stt1,$end1,$c_nu1)=(split(/\s+/,$line))[0,1,2,3];
    next if $c_nu1<5;
    PATH:{
        $line=<DMR>;
        if(!$line){
            print OUT "$chr1\t$stt1\t$end1\n";
        }else{
            my ($chr2,$stt2,$end2,$c_nu2)=(split(/\s+/,$line))[0,1,2,3];
            redo PATH if $c_nu2<5;
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
    perl *.pl <DMR> <OUT>
DIE
}
