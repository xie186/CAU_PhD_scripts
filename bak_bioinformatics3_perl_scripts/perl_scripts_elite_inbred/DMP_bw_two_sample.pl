#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 4;

my ($ot,$ob,$contxt,$merge) = @ARGV;
$ot = "zcat $ot|" if $ot =~ /gz$/;
open CGOT,"$ot"or die;
my (%hash_ot,%hash_ob);
while(<CGOT>){
   my ($chr,$stt,$number,$level) = (split /\s+/,$_)[0,1,3,4];
   my $numberC = ($number * $level)/100;
   $numberC = int($numberC+0.5);
   my $numberT = $number - $numberC;
   push @{$hash_ot{"$chr\t$stt"}},($numberC,$numberT);
}

$ob = "zcat $ob|" if $ob =~ /gz$/;
open CGOB,"$ob" or die;
while(<CGOB>){
   my ($chr,$stt,$number,$level) = (split /\s+/,$_)[0,1,3,4];
   my $numberC = ($number * $level)/100;
   $numberC = int($numberC+0.5);
   my $numberT = $number - $numberC;
   push @{$hash_ob{"$chr\t$stt"}},($numberC,$numberT);
}

open OTOB,"+>$merge" or die;
if($contxt ne "CHH"){
    foreach(keys %hash_ob){
       my ($chr,$stt) = (split /\s+/,$_)[0,1];
       my $stt1 = 0;
       if($contxt eq "CpG" || $contxt eq "CG"){
            $stt1 = $stt - 1;
       }elsif($contxt eq "CHG"){
            $stt1 = $stt - 2;
       }else{
            die "$contxt was wrong!\n";
       }
       if(exists $hash_ot{"$chr\t$stt1"}){
          ${$hash_ot{"$chr\t$stt1"}}[0] += ${$hash_ob{$_}}[0];
          ${$hash_ot{"$chr\t$stt1"}}[1] += ${$hash_ob{$_}}[1];   
       }else{
          ${$hash_ot{"$chr\t$stt1"}}[0] += ${$hash_ob{$_}}[0];
          ${$hash_ot{"$chr\t$stt1"}}[1] += ${$hash_ob{$_}}[1];
       }
    }
}elsif($contxt eq "CHH"){
    foreach(keys %hash_ob){
        my ($chr,$stt) = (split /\s+/,$_)[0,1];
        ${$hash_ot{"$chr\t$stt"}}[0] += ${$hash_ob{$_}}[0];
        ${$hash_ot{"$chr\t$stt"}}[1] += ${$hash_ob{$_}}[1];
    }
}else{
    die "$contxt was wrong!\n";
}

foreach(keys %hash_ot){
   print OTOB "$_\t${$hash_ot{$_}}[0]\t${$hash_ot{$_}}[1]\n";
}

sub usage{
   my $die=<<DIE;
   usage:perl *.pl <OT> <OB> <context> <OTOB>
DIE
}
