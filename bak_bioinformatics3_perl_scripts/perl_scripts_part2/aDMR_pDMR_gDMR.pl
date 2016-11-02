#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 5;
my ($alle,$m_dmr,$p_dmr,$b_dmr,$mo_dmr) = @ARGV;
open ALLE,$alle or die "$!";
open DMRm,"+>$m_dmr"  or die "$!";
open DMRp,"+>$p_dmr"  or die "$!";
open DMRb,"+>$b_dmr"  or die "$!";
open DMRmo,"+>$mo_dmr"  or die "$!";
while(<ALLE>){
    chomp;
    my ($bmb,$bmm,$mbb,$mbm) =(split)[-4,-3,-2,-1];
    if($bmb > $bmm && $mbb < $mbm){
        print DMRm "$_\n";
    }
    if($bmb < $bmm && $mbb > $mbm){
        print DMRp "$_\n";
    }
    if($bmb > $bmm && $mbb > $mbm){
        print DMRb "$_\n";
    }
    if($bmb < $bmm && $mbb < $mbm){
        print DMRmo "$_\n";
    }
}

sub usage{
    my $die=<<DIE;
    perl *.pl <candidate> <mat pDMR > <pat pDMR> <B73 gDMR> <Mo17 gDMR>
DIE
}
