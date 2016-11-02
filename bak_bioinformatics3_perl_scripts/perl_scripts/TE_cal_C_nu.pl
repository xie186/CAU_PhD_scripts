#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==3;
my ($geno,$meth,$context)=@ARGV;
open GENO,$geno or die "$!";
my @aa=<GENO>;
my $join=join('',@aa);
$join=~s/>//;
   @aa=split(/>/,$join);
my $geno_nu=@aa;
my %hash;
for(my $i=0;$i<$geno_nu;++$i){
    my $tem=shift @aa;
    my ($chr,@seq)=split(/\n/,$tem);
    my $seq=join('',@seq);
    $hash{$chr}=$seq;
}

open METH,$meth or die "$!";
while(<METH>){
   chomp;
   my ($chr,$stt,$end,$strand)=split(/\t/,$_);
   $chr="chr".$chr;
   my $tem=substr($hash{$chr},$stt-1,$end-$stt+1);
   my $c_nu=$tem=~s/[CG]/[CG]/g;


   my $tem_cg=substr($hash{$chr},$stt-2,$end-$stt+3);
   my $cg_nu=$tem_cg=~s/CG/CG/g;
      $tem_cg=substr($hash{$chr},$stt-2,2);
      $cg_nu=$cg_nu*2;
      $cg_nu=$cg_nu-1 if $tem_cg eq "CG";
      $tem_cg=substr($hash{$chr},$end-1,2);
      $cg_nu=$cg_nu-1 if $tem_cg eq "CG";
   
   my $tem_chg=substr($hash{$chr},$stt-3,$end-$stt+5);
   my $chg_nu+=$tem_chg=~s/CAG/CAG/g;
      $chg_nu+=$tem_chg=~s/CTG/CTG/g;
      $chg_nu+=$tem_chg=~s/CCG/CCG/g;
      $tem_chg=substr($hash{$chr},$stt-3,3);
      $chg_nu=$chg_nu*2;
      $chg_nu-=1 if $tem_chg=~/C[ATC]G/;
      $tem_chg=substr($hash{$chr},$end-1,3);
      $chg_nu-=1 if $tem_chg=~/C[ATC]G/;
    
   my $chh_nu=$c_nu-$cg_nu-$chg_nu;

    
#   $c_nu=0 if !$c_nu;
   if($context eq "TOL"){
       print "$_\t$c_nu\t$cg_nu\t$chg_nu\t$chh_nu\n";
   }elsif($context eq "CG"){
       print "$_\t$cg_nu\n";
   }elsif($context eq "CHG"){
       print "$_\t$chg_nu\n";
   }elsif($context eq "CHH"){
       print "$_\t$chh_nu\n";
   }else{

   }
  # print "$_\t$c_nu\t$cg_nu\t$chg_nu\t$chh_nu\n"; 
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Genome fasta> <Meth> <Context [TOL][CG][CHG][CHH]> 
DIE
}
