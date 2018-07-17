#!/usr/bin/perl -w
use strict;
die usage() unless  @ARGV == 2;
my ($cmp,$cut) = @ARGV;

my %hash_lap;
open CMP,$cmp or die "$!";
while(<CMP>){
    chomp;
    my ($chr,$pos,$c_nu1,$t_nu1,$c_nu2,$t_nu2,$p_value) = split;
    my $lev1 = $c_nu1 / ($c_nu1+$t_nu1);
    my $lev2 = $c_nu2 / ($c_nu2+$t_nu2);
    ${$hash_lap{"$chr\t$pos"}->{"1"}}[0] = "$lev1\t$lev2";
    print "$_\t$lev1\t$lev2\n" if ($p_value <=0.01 && abs($lev1-$lev2) >= $cut);
}

sub usage{
    print <<DIE;
    perl *.pl <Comparison> <Cutoff>
DIE
   exit 1;
}

