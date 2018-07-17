#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 3;

my ($ot,$ob,$merge) = @ARGV;
open CGOT,"zcat $ot|"or die;
open MER,"+>$merge" or die "$!";
my (%hash_ot,%hash_ob);
while(<CGOT>){
   my ($chr,$stt,$number,$level) = (split /\s+/,$_)[0,1,3,4];
   next if $number < 3;
   my $numberC = ($number * $level)/100;
   $numberC = int($numberC+0.5);
   my $numberT = $number - $numberC;
   print MER "$chr\t$stt\t$numberC\t$numberT\n";
}

open CGOB,"zcat $ob|" or die;
while(<CGOB>){
   my ($chr,$stt,$number,$level) = (split /\s+/,$_)[0,1,3,4];
   next if $number < 3;
   my $numberC = ($number * $level)/100;
   $numberC = int($numberC+0.5);
   my $numberT = $number - $numberC;
   print MER "$chr\t$stt\t$numberC\t$numberT\n";
}
close MER;
sub usage{
   my $die=<<DIE;
   usage:perl *.pl <OT> <OB> <OTOB>
DIE
}
