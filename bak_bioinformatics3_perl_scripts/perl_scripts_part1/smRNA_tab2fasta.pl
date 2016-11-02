#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==2;
my ($tab,$fasta) = @ARGV;
open FA,"+>$fasta" or die "$!";
open TAB,$tab or die "$!";
while(<TAB>){
    chomp;
    next if !/^t/;
    my ($id,$len,$nu,$seq) = split(/\s+/,$_);
       $seq =~ s/U/T/g;
    print FA ">$id\_$len\_$nu\n$seq\n";
}

sub usage{
    my $die =<<DIE;
    perl *.pl <tab> <fasta> 
DIE
}
