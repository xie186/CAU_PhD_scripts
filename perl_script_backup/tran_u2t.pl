#!/usr/bin/perl -w
use strict;
open FA,$ARGV[0];

while(<FA>){
    if(my $find=index($_,"\>")>-1){
        print "$_";
        next;
    }else{
        $_=~tr/U/T/;
        print $_;
  #  print "$_$seq";
    }
}
