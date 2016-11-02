#!/usr/bin/perl -w
open F,"$ARGV[0]";
open O,"+>$ARGV[0]_gai";
while(<F>) {
  chomp;
  $_=~s/\)/R/g;
  $_=~s/\(/L/g;
  print O "$_\n";
}

