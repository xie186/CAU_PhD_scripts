#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==2;
my ($meth_exp, $unseq) = @ARGV;
#        CpG     CHG     CHH     CXX     FPKM
#Aa_0    0.294117647058824       0.478260869565217       0.563380281690141       0.413265306122449       313153

open METH, $meth_exp or die "$!";
my %rec_exp_meth;
while(<METH>){
    chomp;
    next if /CXX/;
    my ($eco, $cpg, $chg,$chh, $cxx, $fpkm) = split;
    $rec_exp_meth{$eco} = "$cpg\t$chg\t$chh\t$cxx\t$fpkm";
}
close METH;

print "chr\tstt\tend\tecotype\tCpG\tCHG\tCHH\tCXX\tFPKM\n";
open UN, $unseq or die "$!";
while(<UN>){
    #chr2    15314796        15314989        Anz_0
    chomp;
    my ($chr, $stt,$end, $eco) = split;
    print "$_\t$rec_exp_meth{$eco}\n" if exists $rec_exp_meth{$eco};
}

close UN;

sub usage{
    my $die =<<DIE;
perl $0 <meth exp> <unseq> 
DIE
}
