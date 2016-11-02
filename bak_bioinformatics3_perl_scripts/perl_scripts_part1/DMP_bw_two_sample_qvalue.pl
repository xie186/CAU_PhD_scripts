#!usr/bin/perl -w
use strict;
use Statistics::R;

#use Data::Dumper;
die usage() if @ARGV == 0;
my $name = $ARGV[0] ;
open Common,$name or die;
#my $name = $ARGV[0] ;
open Qvaluetest,"+>$ARGV[1]" or die;
my $R = Statistics::R ->new();

my $cmd = <<EOF;
library(qvalue)
common<-read.table("$name")
q<-qvalue(common[,10])
EOF
my $run = $R ->run($cmd);

my $i = 0;
while(<Common>){
   ++$i;
   chomp;
   my $qvalue = $R -> get("q\$qvalues[$i]");
   print Qvaluetest "$_\t$qvalue\n";
}

sub usage{
   my $die = <<DIE;
   usage:perl *.pl <P_value> <Qvaluetest>
DIE
}
