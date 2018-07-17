#!/usr/bin/perl -w
use strict;

my ($list, $cut) = @ARGV;

open IN, $list or die "$!";
while(<IN>){
    chomp;
    open CLUS, "tair10_win200bp_inter24nt_smRNA_$_.stat.pval" or die "$!:tair10_win200bp_inter24nt_$_.stat.pval";
    my $stat_num = 0;
    while(my $line = <CLUS>){
        chomp $line;
        #chr1    800     1000    73      9       1.11022302462516e-16 
        my ($chr,$stt,$end, $non_ident, $ident, $p_val) = split(/\t/, $line);
  	$stat_num ++ if $non_ident > $cut;
    }

    print "$_\t$stat_num\n";
}
