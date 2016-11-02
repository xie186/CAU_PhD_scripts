#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==3;
my ($hapmap, $cut_line, $out_prefix) = @ARGV;

open HAP,$hapmap or die "$!";
my $header = <HAP>;
my $stat_line = 0;
while(<HAP>){
    chomp;
    ++$stat_line;
}
close HAP;
open HAP,$hapmap or die "$!";
<HAP>;
my $file_nu = int ($stat_line / $cut_line);
my $resi = $stat_line % $cut_line;
   $file_nu = int ($stat_line / $cut_line) + 1 if $resi > 0;
for(my $i =1; $i <= $file_nu; ++$i){
    open OUT,"+>$out_prefix-$i.hapmap" or die "$!";
    print OUT $header;
    for(my $j = 1; $j <=$cut_line; ++$j){
        my $line = <HAP>;
        last if !$line;
        print OUT $line;
    }
}

print my $log = <<LOG;
=========================
Total SNPs: $stat_line;
SNPs per file: $cut_line;
Number of files: $file_nu;
========================
LOG

sub usage{
    my $die =<<DIE;
    perl *.pl <hapmap> <cut line> <out prefix> 
DIE
}

