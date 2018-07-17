#!/usr/bin/perl -w
use strict;

my ($sam_list) = @ARGV;
open SAM, $sam_list or die "$!";
while(<SAM>){
    chomp;
    open BED, "zcat bed_CXX_OT_$_.txt.gz bed_CXX_OB_$_.txt.gz|" or die "$!";
    my ($t_c_num, $t_dep) = (0, 0);
    while(my $line = <BED>){
        my ($chr,$pos, $c_num, $dep) = split(/\t/, $line);
        next if $chr !~ /chrC/;
        $t_c_num += $c_num;
        $t_dep += $dep;
    }
    close BED;
    my $rate = $t_c_num/$t_dep;
    print "$_\t$t_c_num\t$t_dep\t$rate\n";
}
