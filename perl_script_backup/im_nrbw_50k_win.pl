#!/usr/bin/perl -w
use strict;
#use this script to find the nr_seq th$nrat in 50k windows in NOnr transcripts;
die"Usage:perl *.pl <NRNM><IMMARK>" unless @ARGV==2;
open NRNM,$ARGV[0] or die;
open IMMARK,$ARGV[1] or die;
my $nrname;
my $im_mark;

while ($im_mark=<IMMARK>){
    next if !$im_mark;
    chomp $im_mark;
    my @immark=(split(/\s+/,$im_mark));
    my ($chr1,$stt1,$end1)=(split(/_/,$immark[4]))[1,2,3];
  
     while ($nrname=<NRNM>){
        chomp $nrname;
        my ($chr2,$stt2,$end2)=(split(/_/,$nrname))[1,2,3];
         
        if($chr2 ne $chr1){
            next;
        }elsif($stt2>=$stt1-50000 && $end2<=$end1+50000){
           $immark[1]++;
           $immark[0]="\*$immark[0]";
           push(@immark,$nrname);
        }else{
           next;
        }
    }   
    my $final=join("\t",@immark);
    print "$final\n";
}
