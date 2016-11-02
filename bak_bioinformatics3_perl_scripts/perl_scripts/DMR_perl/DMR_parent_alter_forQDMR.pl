#!/usr/bin/perl -w
use strict;
my ($merged)=@ARGV;
die usage() unless @ARGV==1;
open MER,$merged or die "$!";
print "ID\tchr\tstt\tend\tb73\tmo17\n";
my $i=1;
while(<MER>){
    chomp;
    my ($chr,$stt,$end,$reads1,$lev1,$reads2,$lev2)=split;
    print "$i\t$chr\t$stt\t$end\t$lev1\t$lev2\n";
    ++$i; 
}

sub usage{
    my $die=<<DIE;
    perl *.pl <DMR>  >DMR_forQDMR
DIE
}
