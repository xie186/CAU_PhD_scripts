#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==5;
my ($class1,$class2,$statis,$out1,$out2)=@ARGV;
my %hash_retro;
my %hash_DNA;
open CLASSI,$class1 or die "$!";
while(<CLASSI>){
    chomp;
    my ($class_retro)=(split)[1];
    $hash_retro{$class_retro}++;
}
open CLASSII,$class2 or die "$!";
while(<CLASSII>){
    chomp;
    my ($class_DNA)=(split)[1];
    $hash_DNA{$class_DNA}++;
}

open STA,$statis or die "$!";
my %hash;
my %ele;
my %type;
while(<STA>){
    chomp;
    my ($ele,$type,$nu,$ele_nu,$ele_len)=split;
    $hash{"$ele\t$type"}=$nu*1000000/($ele_len+0.000000001);
    $ele{$ele}++;
    $type{$type}++;
}

open OUT1,"+>$out1" or die "$!";
open OUT2,"+>$out2" or die "$!";
foreach(sort keys %ele){
    print OUT1 "$_\t";
    print OUT2 "$_\t";;
}
print  OUT1 "\n";
print  OUT2 "\n";

foreach(keys %type){
   if(exists $hash_retro{$_}){
       print  OUT1 "$_\t";
       foreach my $ele(sort keys %ele){
           my $nu=0;
           if(exists $hash{"$ele\t$_"}){
               $nu=$hash{"$ele\t$_"};
           }
           print OUT1 "$nu\t";
       }
       print  OUT1"\n";
   }else{
       print OUT2 "$_\t";
       foreach my $ele(sort keys %ele){
           my $nu=0;
           if(exists $hash{"$ele\t$_"}){
               $nu=$hash{"$ele\t$_"};
           }
           print OUT2"$nu\t";
       }
       print  OUT2"\n";
   }
}

sub usage{
    my $die=<<DIE;
    perl *.pl <CLASSI> <CLASSII> <Statistic>  <OUT1> <OUT2>
DIE
}
