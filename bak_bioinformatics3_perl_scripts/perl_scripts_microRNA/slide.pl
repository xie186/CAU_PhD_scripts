#!/usr/bin/perl -w
open F,"$ARGV[0]";
open O,"+>1.sh";
  while(<F>) {
  @ss=split;
  print O "awk '(\$1~/^$ss[0]/)' maize_masked_einverted_want_60_500.fa > maize_masked_einverted_want_60_500_$ss[0].fa\n";
}
close F;
close O;
