#!/usr/bin/perl -w
use strict;
my ($dmr)=@ARGV;
die usage() unless @ARGV==1;

open DMR,$dmr or die "$!";
while(my $line=<DMR>){
    chomp $line;
    my ($chr1, $stt1, $end1, $c_cover1_alle1, $c_nu1_alle1, $t_nu1_alle1, $c_cover1_alle2, $c_nu1_alle2, $t_nu1_alle2, $pval1, $qval1) = split(/\t/,$line);
    my $diff1 =  $c_nu1_alle1 / ($c_nu1_alle1 + $t_nu1_alle1) - $c_nu1_alle2 / ($c_nu1_alle2 + $t_nu1_alle2); 
    if($qval1 < 0.01 && abs($diff1) > 0.3){
        print "$line\n";
    }    
}

sub usage{
    my $die=<<DIE;
    perl *.pl <*fil>
DIE
}
