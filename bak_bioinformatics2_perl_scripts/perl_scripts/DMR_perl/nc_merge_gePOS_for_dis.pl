#!/usr/bin/perl -w
use strict;
my ($dmr,$cutoff,$out)=@ARGV;
die usage() unless @ARGV==3;
open DMR,"sort -k1,1n -k3,3 -k4,4n $dmr |" or die "$!";
open OUT,"+>$out" or die "$!"; 
while(my $line=<DMR>){
    next if $line!~/ID/;
    my ($chr1,$stt1,$end1,$lev1,$lev2)=(split(/\s+/,$line))[2,3,4,6,7];
    my @aa=sort{$a<=>$b}($lev1,$lev2);
    next if ($aa[0]/$aa[1]>1/$cutoff);
    PATH:{
        $line=<DMR>;
        if(!$line){
            print OUT "$chr1\t$stt1\t$end1\n";
        }else{
            my ($chr2,$stt2,$end2,$lev1,$lev2)=(split(/\s+/,$line))[2,3,4,6,7];
            @aa=sort{$a<=>$b}($lev1,$lev2);
            #print "$line" if ($aa[0]/$aa[1]>1/$cutoff);
            next if ($aa[0]/$aa[1]>1/$cutoff);
            
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
    perl *.pl <DMR candidate> <Cutoff 0.5-1.0> <OUT>
DIE
}
