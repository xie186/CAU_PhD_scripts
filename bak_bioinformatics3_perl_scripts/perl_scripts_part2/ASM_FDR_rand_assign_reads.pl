#!/usr/bin/perl -w
use strict;
my ($reads,$out_b73,$out_mo17) = @ARGV;
die usage() unless @ARGV == 3;

open B,"+>$out_b73" or die "$!";
open M,"+>$out_mo17" or die "$!";


open READ, $reads or die "$!";

my $version = <READ>; #  record the version information
print B "$version";  
print M "$version";
while(<READ>){
    my $rand = rand();  # generate the random number
    if($rand <=0.5){
        print B "$_";
    }else{
        print M "$_";
    }
}

sub usage{
    my $die=<<DIE;

    perl *.pl <Reads with informative SNPs> <Random B73 reads OUT> <Random mo17 reads OUT>

DIE
}
