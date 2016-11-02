#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==1;
my ($psl)=@ARGV;
open PSL,$psl or die "$!";
my %hash;
while(<PSL>){
    chomp;
    next if !/^\d/;
    my ($iden,$id,$len)=(split)[0,9,10];
    $hash{$id}++ if $iden/$len>=0.8;
}

foreach(keys %hash){
    print "$_\t$hash{$_}\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <PSL file>
DIE
}
