#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==2;
my ($forw,$cutoff)=@ARGV;
my ($fir,$sec,$thi,$for,$fiv,$six,$sev,$eig,$nine,$ten)=(0,0,0,0,0,0,0,0,0,0);
open FORW,$forw or die "$!";
while(<FORW>){
    my ($chr,$stt,$end,$depth,$lev)=split;
    next if $depth<=$cutoff;
    next if (/chr11/ || /chr0/ || /chr12/ );
                if($lev<=10){
                    $fir++;
                 }elsif($lev<=20 && $lev>10){
                    $sec++;
                }elsif($lev<=30 && $lev>20){
                    $thi++;
                }elsif($lev<=40 && $lev>30){
                    $for++;
                }elsif($lev<=50 && $lev>40){
                    $fiv++
                }elsif($lev<=60 && $lev>50){
                    $six++;
                }elsif($lev<=70 && $lev>60){
                    $sev++;
                }elsif($lev<=80 && $lev>70){
                    $eig++;
                }elsif($lev<=90 && $lev>80){
                    $nine++;
                }else{
                    $ten++
                }
}
my $total=$fir+$sec+$thi+$for+$fiv+$six+$sev+$eig+$nine+$ten;
my @aa=($fir,$sec,$thi,$for,$fiv,$six,$sev,$eig,$nine,$ten);
foreach(@aa){
   print "$_\n"; 
}
sub usage{
    my $die=<<DIE;
    Usage:perl *.pl <Forw> <Depth cutoff value>
DIE
}
