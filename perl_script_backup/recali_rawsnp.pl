#!/usr/bin/perl -w
use strict;
open RAW,$ARGV[0] or die;
while(my $raw=<RAW>){
   chomp $raw;
   my ($chr1,$pos1,$baseR,$nuR,$base1,$nu1,$base2,$nu2)=(split(/\s+/,$raw))[0,1,2,3,4,5,6,7];
#   print "$baseR\t$base1\n";
   if($baseR ne $base1 && $baseR ne $base2){
       next;
   }elsif($baseR ne $base1){
        print "$chr1\t$pos1\t$baseR\t$nuR\t$base2\t$nu2\t$base1\t$nu1\n";
    }else{
        print "$raw\n";
   }
}
