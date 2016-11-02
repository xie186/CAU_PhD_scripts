#!usr/bin/perl -w
use strict;
die usage() unless @ARGV == 3;
open B73,$ARGV[0] or die;
my %hash;
while(<B73>){
   my ($chr,$stt,$numberC,$numberT) = split;
   next if $numberC + $numberT < 5;
   $hash{"$chr\t$stt"} = "$numberC\t$numberT";
}

open Mo17,$ARGV[1] or die;
open SAMESITE,"+>$ARGV[2]" or die;
#print SAMESITE "chromosome\tposition\tB73numberC\tB73numberT\tMo17numberC\tMo17numberT\n";
while(<Mo17>){
   my ($chr,$stt,$numberC2,$numberT2) = split;
   next if $numberC2 + $numberT2 < 5;
   if(exists $hash{"$chr\t$stt"}){
      my ($numberC1,$numberT1) = split /\s+/,$hash{"$chr\t$stt"};
      print SAMESITE "$chr\t$stt\t$numberC1\t$numberT1\t$numberC2\t$numberT2\n";
   }
}

sub usage{
   my $die = <<DIE;
   usage:perl *.pl <B73> <Mo17> <SAMESITE>
DIE
}
