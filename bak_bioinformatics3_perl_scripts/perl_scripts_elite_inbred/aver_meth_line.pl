#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 3;
my ($cpg,$chg,$chh) = @ARGV;
my ($inbred) = $cpg =~ /(BSR\d+)/;
my @cpg = split(/,/,$cpg);
my @chg = split(/,/,$chg);
my @chh = split(/,/,$chh);

my ($total,$tot_c_num) = (0,0);
foreach (@cpg){
    open IN,$_ or die "$!";
    while(my $line = <IN>){
        my ($chr,$stt,$end,$dep,$lev) = split(/\s+/,$line);
        my $c_num = int ($dep*$lev/100 + 0.5);
        $total += $dep;
        $tot_c_num += $c_num;
    }
}
print "$inbred\tCG\t$tot_c_num\t$total\n";

($total,$tot_c_num) = (0,0);
foreach (@chg){
    open IN,$_ or die "$!";
    while(my $line = <IN>){
        my ($chr,$stt,$end,$dep,$lev) = split(/\s+/,$line);
        my $c_num = int ($dep*$lev/100 + 0.5);
        $total += $dep;
        $tot_c_num += $c_num;
    }
}
print "$inbred\tCHG\t$tot_c_num\t$total\n";

($total,$tot_c_num) = (0,0);
foreach (@chh){
    open IN,$_ or die "$!";
    while(my $line = <IN>){
        my ($chr,$stt,$end,$dep,$lev) = split(/\s+/,$line);
        my $c_num = int ($dep*$lev/100 + 0.5);
        $total += $dep;
        $tot_c_num += $c_num;
    }
}
print "$inbred\tCHH\t$tot_c_num\t$total\n";

sub usage{
    my $die = <<DIE;
    perl *.pl <CpG> <CHG> <CHH> 
DIE
}
