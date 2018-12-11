#!/usr/bin/perl -w
use strict;
die "Usage:perl *.pl <SEQ><NR>" unless @ARGV==2;

open SEQ,$ARGV[0] or die;
open NR,$ARGV[1] or die;

my $allseq=join ('',<SEQ>);
my @seq_sin=split(/>/,$allseq);
my $nr;
my $seq;
my $find;
foreach $seq(@seq_sin){
    while($nr=<NR>){
       my ($query,$nr1)=(split(/\s+/,$nr))[0,1];
       if(($find=index($seq,$nr1,0))>-1){
           last;
       }else{
           next;
       }
#       print ">",$seq;
    }
#    print ">",$seq;
  
}
