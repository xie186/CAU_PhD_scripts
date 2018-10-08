#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==2;
my ($ped,$kinship) = @ARGV;

open PED,$ped or die "$!";
my @inbred;
while(<PED>){
    chomp;
    my ($fam, $cau_acc) = split;
    push @inbred, $cau_acc;
}
close PED;

open KIN, $kinship or die "$!";
while (<KIN>){
    my $inbred = shift @inbred; 
    print "$inbred\t$_";
}

sub usage{
    my $die =<<DIE;
    perl *.pl <ped file> <kinship>
    Corresponding to /NAS2/jiaoyp/GWAS/renew-kinship.pl
DIE
}
