#!/usr/bin/perl -w
use strict;
my ($dmr,$out)=@ARGV;
die usage() unless @ARGV==2;
open OUT,"+>$out" or die "$!";
open DMR,"sort -k1,1 -k2,2n $dmr|" or die "$!";
while(my $line=<DMR>){
    chomp $line;
    my ($chr1, $stt1, $end1, $c_cover1_alle1, $c_nu1_alle1, $t_nu1_alle1, $c_cover1_alle2, $c_nu1_alle2, $t_nu1_alle2, $pval1, $qval1) = split(/\t/,$line);
    my $diff1 =  $c_nu1_alle1 / ($c_nu1_alle1 + $t_nu1_alle1) - $c_nu1_alle2 / ($c_nu1_alle2 + $t_nu1_alle2);
    PATH:{
        $line=<DMR>;
        if(!$line){
            print OUT "$chr1\t$stt1\t$end1\n";
        }else{
            chomp $line;
            my ($chr2, $stt2, $end2, $c_cover2_alle1, $c_nu2_alle1, $t_nu2_alle1, $c_cover2_alle2, $c_nu2_alle2, $t_nu2_alle2, $pval2,$qval2) = split(/\s+/,$line);
            my $diff2 =  $c_nu2_alle1 / ($c_nu2_alle1 + $t_nu2_alle1) - $c_nu2_alle2 / ($c_nu2_alle2 + $t_nu2_alle2);
            if($chr2 eq $chr1 && $stt2>=$stt1 && $stt2<=$end1){
                 if (($diff1 > 0 && $diff2 < 0) || ($diff1 < 0 && $diff2 > 0)){
                     print "$chr2\t$stt2\t$end2\t$diff1\t$diff2\n";
                     $line = <DMR>;
                     chomp $line;
                     ($chr1, $stt1, $end1, $c_cover1_alle1, $c_nu1_alle1, $t_nu1_alle1, $c_cover1_alle2, $c_nu1_alle2, $t_nu1_alle2, $pval1, $qval1)= split(/\s+/,$line); 
                     $diff1 =  $c_nu1_alle1 / ($c_nu1_alle1 + $t_nu1_alle1) - $c_nu1_alle2 / ($c_nu1_alle2 + $t_nu1_alle2);
                     redo PATH;
                 }else{
                     $end1=$end2;
                 }
                 redo PATH;
            }else{
                print OUT "$chr1\t$stt1\t$end1\n";
                ($chr1,$stt1,$end1)=($chr2,$stt2,$end2);
                $diff1 = $diff2;
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
