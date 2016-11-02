#!/usr/bin/perl -w
open F,"$ARGV[0]";
open O,"+>$ARGV[1]";
while(<F>) {
 $fir=$_;
 $sed=<F>;
 $thr=<F>;
  print O "$fir$sed";
}
