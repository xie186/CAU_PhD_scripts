#!usr/bin/perl -w
use strict;
die usage() unless @ARGV==5;
open ASM,$ARGV[0] or die;
my %hashASM;
<ASM>;
while(<ASM>){
   my ($chr,$position,$BM_B73numberC,$BM_B73numberT,$BM_Mo17numberC,$BM_Mo17numberT,$MB_B73numberC,$MB_B73numberT,$MB_Mo17numberC,$MB_Mo17numberT,$methylrateBM_B,$methylrateBM_M,$methylrateMB_B,$methylrateMB_M,$fishBM,$fishMB) = split;
   $hashASM{"$chr\t$position"} = "$BM_B73numberC\t$BM_B73numberT\t$BM_Mo17numberC\t$BM_Mo17numberT\t$MB_B73numberC\t$MB_B73numberT\t$MB_Mo17numberC\t$MB_Mo17numberT\t$methylrateBM_B\t$methylrateBM_M\t$methylrateMB_B\t$methylrateMB_M\t$fishBM\t$fishMB";
}

open CG,$ARGV[1] or die;
open RIGHT,"+>$ARGV[2]" or die;
while(<CG>){
   my ($chr,$position) = split;
   $position += 1;
   if(exists $hashASM{"$chr\t$position"}){
      my $key = "$chr\t$position";
      print RIGHT "$key\t$hashASM{$key}\n"; 
   }
}

open GC,$ARGV[3] or die;
open LEFT,"+>$ARGV[4]" or die;
while(<GC>){
   #print"$_";
   #sleep(2);
   my ($chr,$position) = split;
   $position += 1;
   #print"$chr\t$position\n";
   #sleep(2);
   if(exists $hashASM{"$chr\t$position"}){
      #print"$chr\t$position\n";
      my $key = "$chr\t$position";
      print LEFT "$key\t$hashASM{$key}\n";
   }
}

sub usage{
   my $die = <<DIE;
   usage:perl *.pl <ASM> <CG> <RIGHT> <GC> <LEFT>
DIE
}

