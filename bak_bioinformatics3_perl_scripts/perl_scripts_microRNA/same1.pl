#!/usr/bin/perl -w
open F,"$ARGV[0]";
  while(<F>) {
chomp;
  @ss=split;
  $ss[0]=~s/>//;
  $hash{$ss[0]}=$ss[1];
}
open I,"$ARGV[1]";
open O,"+>$ARGV[1]_gai";
while(<I>) {
chomp;
@dd=split;
  if(exists($hash{$dd[1]})) {
  if($dd[2]>=100&&$dd[3]==$hash{$dd[1]}) {
   print O "$_\n";
}
}
}
