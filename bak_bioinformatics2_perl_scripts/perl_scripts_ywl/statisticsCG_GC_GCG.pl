#!usr/bin/perl -w
use strict;
die usage() unless @ARGV == 3;
open GENOME,$ARGV[0] or die;
my @aa = <GENOME>;
my $seq = join('',@aa);
@aa = split />/,$seq;
shift @aa;
my %hash_chrseq;
foreach(@aa){
   my @ss = split /\n/,$_;
   my $chr = shift @ss;
   my $chrseq = join('',@ss);
   $hash_chrseq{$chr} = $chrseq;
}

my (@position1,@position2);
foreach(keys %hash_chrseq){
   my $stt = 0;
   my $result =0;
   while($result != -1){
      $result = index($hash_chrseq{$_},"C",$stt);
      my $letter1 = substr($hash_chrseq{$_},$result-1,1);
      my $letter2 = substr($hash_chrseq{$_},$result+1,1);
      if($letter2 eq "G"){
         push @position1,"$_\t$result";   
      }
      if($letter1 eq "G" && $letter2 ne "G"){
         push @position2,"$_\t$result";
      }
      $stt = $result + 1;
   }
}

open RIGHT,"+>$ARGV[1]" or die;
open LEFT,"+>$ARGV[2]" or die;
foreach(@position1){
   print RIGHT "$_\n";
}

foreach(@position2){
   print LEFT "$_\n";
}

sub usage{
   my $die = <<DIE;
   usage:perl *.pl <GENOME> <RIGHT> <LEFT>
DIE
} 
