#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 4;
my ($qvalue,$context,$out1,$out2) = @ARGV;

open OUT1, "+>$out1" or die "$!";
open OUT2, "+>$out2" or die "$!";
open QVALUE,$qvalue or die "$!";
while(<QVALUE>){
    chomp; 
    next if /NA/;
    my ($chr,$pos,$c1,$t1,$c2,$t2,$c3,$t3,$c4,$t4,$p1,$p2,$q1,$q2)  = split;
    if($q1 <=0.05 || $q2 <=0.05){
        #print "$_\n";
        next;
    }
    print OUT1 "$_\n";
    print OUT2 "$_\n";
    if($context eq "CpG"){
         $pos = $pos + 1;
         print OUT2 "$chr\t$pos\t$c1\t$t1\t$c2\t$t2\t$c3\t$t3\t$c4\t$t4\t$p1\t$p2\t$q1\t$q2\n";
    }elsif($context eq "CHG"){
         $pos = $pos + 2;
         print OUT2 "$chr\t$pos\t$c1\t$t1\t$c2\t$t2\t$c3\t$t3\t$c4\t$t4\t$p1\t$p2\t$q1\t$q2\n";
    }
}

sub usage{
    my $die =<<DIE;
    perl *.pl <qvalue file> <context [CpG CHG]> <out1 for diff fig> <out2 for common sites> 
DIE
}
