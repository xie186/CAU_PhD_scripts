#!/usr/bin/perl -w
open F,"$ARGV[0]";
open O,"+>$ARGV[1]";
while(<F>) {
  chomp;
  if($_!~/^>/) {
  $reverse=reverse($_);
  $reverse=~tr/A|T|C|G/T|A|G|C/;
  print O "$reverse\n";
}
else { print O "$_\n";}
}


