#!/usr/bin/perl -w
use strict;
my $die=<<DIE;
Usage:perl *.pl <EmForw><EmRev><EndoForw><EndoRev><ReferenceGenome><OutputFile>.
DIE
die "$die" unless @ARGV==6;
my ($emf,$emr,$enf,$enr,$ref,$out)=@ARGV;
open REF,$ref or die "$!";
my @ref=<REF>;
$ref=~/(chr\d*)/;
shift @ref;
chomp @ref;
my $seq=join '',@ref;
@ref=();
close REF;

if(-e $out){
    print "Output file exists!!!Failed\n";
    exit;
}else{
    print "$1 Start!!!\n";
    open OUT,"+>$out";
}
open EMF,$emf or die "$!";
open EMR,$emr or die "$!";
open ENF,$enf or die "$!";
open ENR,$enr or die "$!";
my @emFcal;my @emRcal;my @enFcal;my @enRcal;
for(my $i=1;$i<=300;++$i){
    my $tem=<EMF>;
    push @emFcal,$tem;
    $tem=<EMR>;
    push @emRcal,$tem;
    $tem=<ENF>;
    push @enFcal,$tem;
    $tem=<ENR>;
    push @enRcal,$tem;
}
my $chrLen=length($seq);
my $chrpos=0;
for(my $i=1;$i<=$chrLen-299;$i+=50){
    my $em300=0;my $en300=0;my $methyc=0;
    for(my $j=1;$j<=300;++$j){
        $chrpos+=1;
        my $base=substr($seq,$j-1,1);
        if($base eq "C"){
              my @emaln=split(/\s+/,$emFcal[$j-1]);
              my @enaln=split(/\s+/,$enFcal[$j-1]);
              if($emaln[1]+$emaln[3]>=4 && $enaln[1]+$enaln[3]>=4){
                  my $emLev=$emaln[1]/($emaln[1]+$emaln[3]);
                  my $enLev=$enaln[1]/($enaln[1]+$enaln[3]);
                  $em300+=$emLev;
                  $en300+=$enLev;
                  $methyc++;
              }
          }elsif($base eq "G"){
              my @emaln=split(/\s+/,$emRcal[$j-1]);
              my @enaln=split(/\s+/,$enRcal[$j-1]);
              if($emaln[1]+$emaln[3]>=4 && $enaln[1]+$enaln[3]>=4){
                  my $emLev=$emaln[1]/($emaln[1]+$emaln[3]);
                  my $enLev=$enaln[1]/($enaln[1]+$enaln[3]);
                  $em300+=$emLev;
                  $en300+=$enLev;
                  $methyc++;
              }
          }
    }
    if($methyc!=0 && $em300!=0 && $en300!=0){
         my $emLevT=$em300/$methyc;
         my $enLevT=$en300/$methyc;
         my $em_endo=($emLevT-$enLevT)/(($emLevT+$enLevT)**0.5);
         printf OUT ("%s\t%d\t%.3f\n",$1,$i,$em_endo);
     }
     for(my $h=1;$h<=50;++$h){
         shift @emFcal;shift @emRcal;shift @enFcal;shift @enRcal;
         my $tem=<EMF>;
         push @emFcal,$tem;
         $tem=<EMR>;
         push @emRcal,$tem;
         $tem=<ENF>;
         push @enFcal,$tem;
         $tem=<ENR>;
         push @enRcal,$tem;         
     }
}
print "ChrPosFinalValue:$chrpos\tchromosomeLength:$chrLen\n";
close EMF;close EMR;close ENF;close ENR;
