#!/usr/bin/perl -w
use strict;
my $die=<<DIE;
perl *.pl *.pl <chr2_cluster.txt><chr2_cluster.imp><OUT_cre1> Get the gene not imprinted under criteria 5
DIE
die "\n$die\n" unless @ARGV==4;
open IMP,$ARGV[0] or die;
my %hash;
while(<IMP>){
    chomp;
    my @cc=split;
    $hash{$cc[0]}++;
}

open ALL,$ARGV[2] or die;
open OUT,"+>$ARGV[3]" or die;
while(<ALL>){
   chomp;
   my @aa=split;
   my @im;
   if(exists $hash{$aa[0]}){
      next;
   }else{
      open SNP,$ARGV[1] or die;
      while(my $snpl=<SNP>){
          chomp $snpl;
          my @snp=split(/\s+/,$snpl);
          next if ($snp[1] ne $aa[3])
          if($snp[-1]<=0.05 && $snp[-2]<=0.05){
              my $imcret1=&cret1($snp[2],$snp[3],$snp[4],$snp[5]);
              push(@im,$imcret1);
          }
       }
       
   }
   print "$_\t@im\n" if (@im);
}
close ALL;

sub cret1{
    my $return;
    if($_[0]/($_[0]+$_[1])>2/3 && $_[3]/($_[2]+$_[3])>2/3){
        $return="mat";
    }elsif($_[1]/($_[0]+$_[1])>1/3 && $_[2]/($_[2]+$_[3])>1/3){
        $return="pat";
    }else{
         $return="NO";
    }
    return $return;
}
