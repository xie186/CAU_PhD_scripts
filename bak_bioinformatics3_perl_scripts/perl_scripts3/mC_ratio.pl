#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 3;
my ($cg,$chg,$chh) = @ARGV;

my ($cg_nu,$chg_nu,$chh_nu) = (0,0,0);
open CG,$cg or die "$!";
while(<CG>){
    chomp;
    my ($chr,$stt,$end,$depth,$lev) =split;
    next if ($depth < 3);
    next if ($lev <= 80);
    ++ $cg_nu;
}

open CHG,$chg or die "$!";
while(<CHG>){
    chomp;
    my ($chr,$stt,$end,$depth,$lev) =split;
    next if ($depth < 3);
    next if ($lev <= 80); 
    ++ $chg_nu;
}

open CHH,$chh or die "$!";
while(<CHH>){
    chomp;
    my ($chr,$stt,$end,$depth,$lev) =split;
    next if ($depth < 3);
    next if ($lev <= 80);
    ++ $chh_nu;
}

print "CpG\t$cg_nu\nCHG\t$chg_nu\nCHH\t$chh_nu\n";
sub usage{
    my $die=<<DIE;
    perl *.pl <CG> <CHG> <CHH>
DIE
}
