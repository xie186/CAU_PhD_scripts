#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==2;
my ($gff,$ge_nt)=@ARGV;

open GFF,$gff or die "$!";
my %hash_intron;
while(<GFF>){
    chomp;
    my ($chr,$ele,$stt,$end,$strand,$name)=(split)[0,2,3,4,6,8];
    next if ($chr eq "Mt" || $chr eq "Pt" || $chr eq "UNKNOWN" || $ele ne "intron");
    ($name)=(split(/=/,(split(/;/,$name))[0]))[1];
    $name=~s/_T\d+// if $name=~/GRMZM/;
    $chr="chr".$chr;
  #  $name =~ s/FGT/FG/;
    if($end-$stt+1<=100){
        $hash_intron{$name}++;
    }
}

open NT,$ge_nt or die "$!";
my %hash_ge;
while(<NT>){
     chomp;
     next if /#/;
     my ($chr,$stt,$end,$gene)=split;
     if(!exists $hash_intron{$gene}){
         print "$_\tYES\n";
     }else{
         print "$_\tNO\n";    ### with a intron whose length is shorter thant 150;
     }
}

sub usage{
    my $die=<<DIE;
    perl *.pl <GFF>  <Genes without TEs within gene region> >?Genes with a intron larger than 100 or not
DIE
}
