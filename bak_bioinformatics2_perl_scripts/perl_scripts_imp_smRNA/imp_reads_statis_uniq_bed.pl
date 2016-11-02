#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==1;
my ($bed) = @ARGV;
open BED,$bed or die "$!";
my %sm_uniq;
my %sm_nu;
my ($sm_uniq_tot,$sm_nu_tot) = (0,0);
while(<BED>){
    chomp;
    my ($chr,$stt,$end,$id)= split;
    my ($sm_id,$len,$nu) = split(/_/,$id);
    $sm_uniq{$len} ++;
    $sm_nu{$len} += $nu;
    $sm_uniq_tot ++;
    $sm_nu_tot += $nu;
}

foreach(keys %sm_uniq){
    chomp;
    print "$_\t$sm_uniq{$_}\t$sm_uniq_tot\t$sm_nu{$_}\t$sm_nu_tot\n";
}
sub usage{
    my $die=<<DIE;
    perl *.pl <Uniqe mapped reads smRNA> 
DIE
}
