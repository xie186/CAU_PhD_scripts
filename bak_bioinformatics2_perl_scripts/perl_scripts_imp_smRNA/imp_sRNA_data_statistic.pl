#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==1;
my ($fa) = @ARGV;
my ($read_nu,$seq_nu,$base_nu) = (0,0,0);
open FA,$fa or die "$!";
while(<FA>){
    chomp;
    next if !/^>/;
    my ($id,$len,$nu) = split(/_/,$_);
    ++ $read_nu;
    $seq_nu += $nu;
    $base_nu += $len;
}

print "$fa\t$read_nu\t$seq_nu\t$base_nu\n";

sub usage{
    my $die=<<DIE;
    perl *.pl <smRNA>  
    We use this scripts to do statistics of smRNA data.
DIE
}
