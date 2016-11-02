#!/usr/bin/perl -w
open F,"$ARGV[0]";
open O,"+>$ARGV[1]";
while(<F>) {
chomp;
  $_=~s/;/\t/g;
  @ss=split;
  if($ss[2]>=5&&$ss[3]>=100&&$ss[4]>=20&&$ss[4]<=22) {

  print O "$_\n";

}
}

