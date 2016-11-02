#!/usr/bin/perl -w
use strict; 
die usage() unless @ARGV==4;
my ($geno,$out1,$out2,$out3)=@ARGV;
open GENO,$geno or die "$!";
my @tem=<GENO>;
chomp @tem;
my $chr=shift @tem;
   $chr=~s/>//;
my $seq=join'',@tem;

my %seven;my ($cpg,$chg,$chh,$h)=(0,0,0,0);
open OUT1,"+>$out1" or die "$!";
open OUT2,"+>$out2" or die "$!";
open OUT3,"+>$out3" or die "$!";
my $lim=100000;
while((my $find=index($seq,"C",$h))){
  my $seq_tem=substr($seq,$find-5,12);
  if($seq_tem=~/\w{5}CG\w{5}/){
      if($cpg<=$lim){
         print OUT1 ">$h\n$seq_tem\n";
         ++$cpg;
      }
  }elsif($seq_tem=~/\w{5}C[ATC]G\w{4}/){
      if($chg<=$lim){
         print OUT2 ">$h\n$seq_tem\n";
         ++$chg;
      }
  }else{
      if($chh<=$lim){
         print OUT3 ">$h\n$seq_tem\n";
         ++$chh;
      }
  }
  last if ($cpg==$lim+1 && $chg==$lim+1 && $chh==$lim+1);
  $h=$find+1; 
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Genome> <OUT CpG> <CHG> <CHH>
DIE
}
