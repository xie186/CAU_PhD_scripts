#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==1;
my ($rfam)=@ARGV;
open RFAM,$rfam or die "$!";
my @aa=<RFAM>;
my $join=join'',@aa;
   $join=~s/>//;
   @aa=split(/>/,$join);
foreach(@aa){
    print ">$_" if (/rRNA/ || /tRNA/);
    
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Rfam> 
DIE
}
