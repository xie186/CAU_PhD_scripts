#!/usr/bin/perl -w
use strict;

die "Usage:perl *.pl<FASTA><PILEUP>" unless @ARGV==2;
open FA,$ARGV[0] or die;
#open PI,$ARGV[1] or die;
my $tr_name;
my $ct_cov;
my $i;
while($tr_name=<FA>){
    my $seq=<FA>;
    chomp $tr_name;
    my($chr,$stt,$end)=(split(/_/,$tr_name))[1,2,3];
    open PI,$ARGV[1] or die;
    my $pile;
    while($pile=<PI>){
       chomp $pile;
       my ($chr1,$pos,$cov)=(split(/\s+/,$pile))[0,1,3];
       if($chr1 ne $chr){
           next;
       }elsif($pos>=$stt && $pos<=$end){
           $ct_cov+=$cov;
           $i++;
       }
    }
}

my $aver_cov=$ct_cov/$i;
printf "%.2f\n",$aver_cov;
