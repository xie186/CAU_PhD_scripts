#!/usr/bin/perl -w
open F,"$ARGV[0]";
open O,"+>$ARGV[1]";
while(<F>) {
 chomp;
 $fir=$_;
 $sed=<F>;
 chomp($sed);
 $length=length($sed);
 if($length>=60&&$length<=500) {
 print O "$fir\n$sed\n";
}
 }

