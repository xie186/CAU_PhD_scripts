#!usr/bin/perl -w
use strict;
use Text::NSP::Measures::2D::Fisher::twotailed;
die usage() if @ARGV == 0;
open Inbred1,$ARGV[0] or die;
my %hash;
while(<Inbred1>){
   my ($chr,$site,$C1,$T1) = split;
   $hash{"$chr\t$site"} = "$C1\t$T1";
}

open Inbred2,$ARGV[1] or die;
open Common,"+>$ARGV[2]" or die;
while(<Inbred2>){
   my ($chr,$site,$C2,$T2) = split;
   if(exists $hash{"$chr\t$site"}){
      my ($C1,$T1) = split /\s+/,$hash{"$chr\t$site"};
      my $npp = $C1 + $T1 + $C2 + $T2;
      my $np1 = $C1 + $C2;
      my $n1p = $C1 + $T1;
      my $n11 = $C1;
      my $p_value = calculateStatistic(n11=>$n11,n1p=>$n1p,np1=>$np1,npp=>$npp);
      $p_value = 1 if $p_value > 1;
      my $methy1 = 100*$C1/($C1+$T1);
      my $methy2 = 100*$C2/($C2+$T2);
      my $diffmethy = $methy1 - $methy2;
      print Common "$chr\t$site\t$C1\t$T1\t$C2\t$T2\t$methy1\t$methy2\t$diffmethy\t$p_value\n";
   }
}

sub usage{
   my $die = <<DIE;
   usage:perl *.pl <Inbred1> <Inbred2> <Common>
DIE
}

    
