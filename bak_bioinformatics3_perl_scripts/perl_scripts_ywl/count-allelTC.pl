#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 3;
open CGOT,$ARGV[0] or die;
my (%hash_ot,%hash_ob);
while(<CGOT>){
   my ($chr,$stt,$number,$level) = (split /\s+/,$_)[0,1,3,4];
   next if $number < 3;
   my $numberC = ($number * $level)/100;
   $numberC = int($numberC+0.5);
   my $numberT = $number - $numberC;
   push @{$hash_ot{"$chr\t$stt"}},($numberC,$numberT);
}

open CGOB,$ARGV[1] or die;
while(<CGOB>){
   my ($chr,$stt,$number,$level) = (split /\s+/,$_)[0,1,3,4];
   next if $number < 3;
   my $numberC = ($number * $level)/100;
   $numberC = int($numberC+0.5);
   my $numberT = $number - $numberC;
   push @{$hash_ob{"$chr\t$stt"}},($numberC,$numberT);
}

my ($i,$j);
open OTOB,"+>$ARGV[2]" or die;
foreach(keys %hash_ob){
   my ($chr,$stt) = (split /\s+/,$_)[0,1];
   my $stt1 = $stt - 1;
   my $stt2 = $stt + 1;
   #print"$chr\t$stt\n";
   #sleep(2);
   if(exists $hash_ot{"$chr\t$stt1"}){
      ${$hash_ot{"$chr\t$stt1"}}[0] += ${$hash_ob{$_}}[0];
      ${$hash_ot{"$chr\t$stt1"}}[1] += ${$hash_ob{$_}}[1];   
      ++$i;
      #my $c = ${$hash_ot{"$chr\t$stt1"}}[0];
      #my $t = ${$hash_ot{"$chr\t$stt1"}}[1];
      #print"$c\t$t\n";
      #sleep(2);
   }
   if(!exists $hash_ot{"$chr\t$stt1"} && exists $hash_ot{"$chr\t$stt2"}){
      ${$hash_ot{"$chr\t$stt2"}}[0] += ${$hash_ob{$_}}[0];
      ${$hash_ot{"$chr\t$stt2"}}[1] += ${$hash_ob{$_}}[1];   
      ++$j;
      #my $a = ${$hash_ot{"$chr\t$stt2"}}[0];
      #my $b = ${$hash_ot{"$chr\t$stt2"}}[1];
      #print"$chr\t$stt2\t$a\t$b\n";
      #sleep(2);
   }
}

print"$i\t$j\n";
foreach(keys %hash_ot){
   #my ($chr,$stt) = (split /\s+/,$_)[0,1];
   #print"$chr\t$stt\n";
   #sleep(2);
   print OTOB "$_\t@{$hash_ot{$_}}\n";
}

sub usage{
   my $die=<<DIE;
   usage:perl *.pl <CGOTB73> <CGOBB73> <CGOTOBB73>
DIE
}
