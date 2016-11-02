#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==1;
my ($tab)=@ARGV;
my %hash;
open TAB,$tab or die "$!";
while(<TAB>){
    chomp;
    my ($id,$len,$nu,$strand,$chr,$pos) =split;
    $hash{$len}+=$nu;
}

foreach(sort{$a<=>$b}keys %hash){
    print "$_\t$hash{$_}\n";
}
sub usage{
    my $die=<<DIE;
    perl *.pl <smRNA table>
DIE
}
