#!/usr/bin/perl -w
open F,"$ARGV[0]";
while(<F>) {
chomp;
 @ss=split;
 $hash{$ss[0]}=$_;
}
open I,"$ARGV[1]";
open O,"+>$ARGV[1]_max";

while(<I>) {
  chomp;
  @dd=split;
     if(exists($hash{$dd[0]})) {
       print O "$hash{$dd[0]}\n";
}
}

