#!usr/bin/perl -w
use strict;
use Statistics::R;
#use Data::Dumper;
die usage() if @ARGV == 0;
my $name = $ARGV[0] ;
open Fish,$name or die;
#my $name = $ARGV[0] ;
open Qvaluetest,"+>$ARGV[1]" or die;
my $R = Statistics::R ->new();
my $cmd = <<EOF;
library(qvalue)
#fisher<-read.table("$name",head=T)
fisher<-read.table("$name")
qBM<-qvalue(fisher[,11])
qMB<-qvalue(fisher[,12])
EOF
my $run = $R ->run($cmd);
my $i = 0;
while(<Fish>){
   chomp;
   ++ $i;
   my $BM_q_value = $R -> get("qBM\$qvalues[$i]");
   my $MB_q_value = $R -> get("qMB\$qvalues[$i]");
   print Qvaluetest "$_\t$BM_q_value\t$MB_q_value\n";
}

sub usage{
   my $die = <<DIE;
   usage:perl *.pl <P_value> <Qvaluetest>
DIE
}

