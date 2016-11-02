#!/usr/bin/perl -w
use strict;
die usage() if @ARGV == 0;
open CGOT,"zcat $ARGV[0] |" or die;
my (%hash_ot,%hash_ob);
while(<CGOT>){
   my ($chr,$stt,$number,$level) = (split /\s+/,$_)[0,1,3,4];
   #next if $number < 3;
   my $numberC = ($number * $level)/100;
   $numberC = int($numberC+0.5);
   my $numberT = $number - $numberC;
   push @{$hash_ot{"$chr\t$stt"}},($numberC,$numberT);
}

open CGOB,"zcat $ARGV[1] |" or die;
while(<CGOB>){
   my ($chr,$stt,$number,$level) = (split /\s+/,$_)[0,1,3,4];
   #next if $number < 3;
   my $numberC = ($number * $level)/100;
   $numberC = int($numberC+0.5);
   my $numberT = $number - $numberC;
   push @{$hash_ob{"$chr\t$stt"}},($numberC,$numberT);
}

open OTOB,"+>$ARGV[2]" or die;
foreach(keys %hash_ot){
   my ($chr,$stt) = (split /\s+/,$_)[0,1];
   my $stt1 = $stt + 1;
   if(exists $hash_ob{"$chr\t$stt1"}){
      ${$hash_ot{$_}}[0] += ${$hash_ob{"$chr\t$stt1"}}[0];
      ${$hash_ot{$_}}[1] += ${$hash_ob{"$chr\t$stt1"}}[1];
      delete($hash_ob{"$chr\t$stt1"});
   }
}

foreach(keys %hash_ot){
   print OTOB "$_\t@{$hash_ot{$_}}\n";
}

foreach(keys %hash_ob){
   my ($chr,$site) = split;
   $site -= 1;
   print OTOB "$chr\t$site\t@{$hash_ob{$_}}\n";
}

sub usage{
   my $die=<<DIE;
   usage:perl *.pl <CG_OT> <CG_OB> <CG_OTOB>
DIE
}

