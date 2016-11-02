#!/usr/bin/perl -w
open F,"$ARGV[0]";
  while(<F>) {
chomp;
  @ss=split;
  $one=">".$ss[0];
  $hash{$one}=$_;
}
open I,"$ARGV[1]";
open O,"+>$ARGV[0]_seq";
while(<I>) {
chomp;
$fir=$_;
  $sed=<I>;
chomp($sed);
  if(exists($hash{$fir})) {
   print O "$fir\n$sed\n";
}
}

