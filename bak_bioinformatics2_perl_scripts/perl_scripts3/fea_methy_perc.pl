#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==2;
my ($forw,$cutoff)=@ARGV;
my ($fir,$sec,$thi,$for,$fiv,$six,$sev,$eig,$nine,$ten)=(0,0,0,0,0,0,0,0,0,0);
open FORW,$forw or die "$!";
my $total=0;
while(<FORW>){
    my ($chr,$stt,$end,$depth,$lev)=split;
    next if ($depth<=$cutoff);             ## Methylation level equal 0 are included !!
    next if (/chr11/ || /chr0/ || /chr12/ || /chrmitochondria/ || /chrchloroplast/);
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
     ++$total;
}
my @aa=($fir,$sec,$thi,$for,$fiv,$six,$sev,$eig,$nine,$ten);
#my @lab=("<=10","10-20","20-30","30-40","40-50","50-60","60-70","70-80","80-90","90-100");
my $i=0;
foreach(@aa){
   my $perc=$_/$total;
   print "$i\t$_\t$total\t$perc\n";
   ++$i;
}
sub usage{
    my $die=<<DIE;
    Usage:perl *.pl <Forw> <Depth cutoff value>
DIE
}
