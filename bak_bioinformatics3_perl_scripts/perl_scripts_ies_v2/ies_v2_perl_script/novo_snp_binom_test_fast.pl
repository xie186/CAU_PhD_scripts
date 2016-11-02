#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==2;
my ($snp,$out) = @ARGV;
open SNP,$snp or die "$!";
open OUT,"+>$out" or die;
while(<SNP>){

    my ($chr,$pos,$ref,$ref_nu,$alle1,$nu1,$alle2,$nu2) =split;
    my $pvalue="NULL";
#       $pvalue=test($nu2,$ref_nu,0.05,"great");
    
    print OUT "p_value<-binom.test($nu2,$ref_nu,0.05,alternative=\"greater\")\$p.value\ncat(\"$chr\t$pos\t$ref\t$ref_nu\t$alle1\t$nu1\t$alle2\t$nu2\",\"\\t\",as.character(p_value),\"\\n\")\n";
}

system("R --vanilla --slave < $out > $out.binom_test");

sub usage{
    print <<DIE;
    perl *.pl <SNP> <output>
DIE
    exit 1;
}
