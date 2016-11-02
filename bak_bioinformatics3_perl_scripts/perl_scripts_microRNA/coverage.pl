#!/usr/bin/perl -w
open F,"$ARGV[0]";
open O,"+>$ARGV[0]_gai";
while(<F>) {
 chomp;
 @ss=split;
 @dd=split/_/,$ss[0];
 $n=$dd[2]-$dd[1]+1;
 $m=$ss[3]/$n;
 $p=$ss[2]*$m;
 print O "$ss[1]\t$ss[0]\t$p\n";
}
 
