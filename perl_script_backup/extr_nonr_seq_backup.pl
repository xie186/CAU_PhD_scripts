#!/usr/bin/perl -w 
#use strict;
die "Usage:perl *.pl <SEQ><NR>" unless @ARGV==2;
open SEQ,$ARGV[0] or die;
open NR,$ARGV[1] or die;
my %hash;
my @nr_seq=<NR>;
foreach(@nr_seq){
    my $sub=substr($_,7);
#    print $sub;
    $hash{$sub}++;
}

my $seq;
my $head;
while($head=<SEQ>){
   $seq=<SEQ>;
#   print $seq;
   my ($find)=(split(/>/,$head))[1];
#   print $find;
#   print $find,"asdfa\n";
   if (exists $hash{$find}){
       next;
   }else{
       print ">",$head,"$seq";
   } 
}
