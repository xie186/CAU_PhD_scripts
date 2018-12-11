#!/usr/bin/perl

print "asfsa\n";
foreach(1..10){
   if($_==5){
      next;
   }
   print $_;
}
