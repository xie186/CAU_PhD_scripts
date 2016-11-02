#!/usr/bin/perl -w
open F,"$ARGV[0]";
open O,"+>$ARGV[1]";
while(<F>) {
  chomp;
  if($_=~/^>/) {
  print O "\n$_\n";
}else{print O "$_";}
}

