#!/usr/bin/perl -w
use strict;
die "Usage:perl *.pl <CCrich><TRANSPOSON>" unless @ARGV==2;
#open MIP,$ARGV[1] or die;
open GCRI,$ARGV[0] or die;

while(my $gc=<GCRI>){
    chomp $gc;
    my ($gepair,$pos)=(split(/\s+/,$gc))[0,1];
 #   print "$pos\n";
    my ($gene1)=(split(/_/,$gepair))[1];
    open MIP,$ARGV[1] or die;
    while(my $mip=<MIP>){
        my $find;
        chomp $mip;
        if($find=index($mip,$gene1,0)>-1){
         #   print "$mip\n";
            my ($pa1_stt1,$stt1,$end1)=(split(/\s+/,$mip))[1,7,8];
 #          print "$pos\t$stt1\t$end1\n";
            if($pos>=$stt1-$pa1_stt1+1 && $pos+13<=$end1-$pa1_stt1+1){
                print "$gc\n";
#                 print "";
            }
        }else{
            next;
        }
    }
}
