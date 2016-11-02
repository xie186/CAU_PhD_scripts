#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my ($dms, $cutoff) = @ARGV;
open DMS,$dms or die "$!";
my $dms_num = 0;
my @all_sites;

#increase decrease
my ($par_diff, $pDMS) = (0,0);
my ($par_noDiff, $sDMS) = (0,0);
while(<DMS>){
    chomp;
    my ($chr,$stt,$end,$c1,$t1,$c2,$t2,$lev1,$lev2,$diff,$pval,$qval,$jug) = split;
    if($jug eq "Y"){
        ++ $par_diff;
        ++ $pDMS if $qval < $cutoff;
    }else{
        ++ $par_noDiff;
        ++ $sDMS if $qval < $cutoff;
    }
}

print "pDMS\t$par_diff\t$pDMS\n";
print "sDMS\t$par_noDiff\t$sDMS\n";
sub usage{
    my $die =<<DIE;
    perl *.pl <DMS> <cutoff>
DIE
}
