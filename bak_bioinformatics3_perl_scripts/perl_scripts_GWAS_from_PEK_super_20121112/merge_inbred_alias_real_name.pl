#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==2;
my ($alias,$real_name) = @ARGV;
open REAL,$real_name or die "$!";
my @real_name;
while(<REAL>){
    chomp;
    push @real_name,$_;
}

open ALIAS,$alias or die "$!";
my $i = 0;
while(<ALIAS>){
    chomp;
    print "$_\t$real_name[$i]\n";
    ++$i;
}

sub usage{
    my $die =<<DIE;
    perl *.pl <inbread alias name> <inbread real name> 
DIE
}
