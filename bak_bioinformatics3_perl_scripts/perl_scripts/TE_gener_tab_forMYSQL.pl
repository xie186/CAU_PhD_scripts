#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==1;
my ($meth)=@ARGV;
open METH,$meth or die "$!";
while(<METH>){
    chomp;
    my ($chr,$stt,$end,$strand,$type1,$type2,$c_cov,$meth_lev,$c_nu)=split(/\t/);
    my $mid=int (($end+$stt)/2);
    next if(!$c_nu || $c_cov/($c_nu+0.0000001)<0.3 || $c_cov<=10);
    print "$chr\t$mid\t$stt\t$end\t$strand\t$type1\t$c_cov\t$meth_lev\t$c_nu\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl  <Meth TE> 
DIE
}
