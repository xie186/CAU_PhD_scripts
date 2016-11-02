#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==2;
my ($rpkm,$cpg_oe)=@ARGV;
open RPKM,$rpkm or die "$!";
my %hash_exp;
while(<RPKM>){
    chomp;
    my ($gene,$rpkm)=(split)[0,-1];
    $hash_exp{$gene}=$rpkm;
}
close RPKM;

open CPG,$cpg_oe or die "$!";
while(<CPG>){
     chomp;
     my ($chr,$stt,$end,$gene,$strand,$cpg)=(split)[0,1,2,3,4,11];
     my $exp=0;
        $exp=$hash_exp{$gene} if exists $hash_exp{$gene};
     print "$chr\t$stt\t$end\t$gene\t$strand\t$cpg\t$exp\n";
}


sub usage{
    my $die=<<DIE;
    perl *.pl <RPKM> <CpG O/E> 
DIE
}
