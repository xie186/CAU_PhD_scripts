#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==2;
my ($dmr, $context) = @ARGV;

my @dmr = split(/,/, $dmr);
my @context = split(/,/, $context);

for(my $i = 0 ;$i < @dmr; ++$i){
    open DMR,$dmr[$i] or die "$!";
    while(<DMR>){
        chomp; 
        print "$_\t$context[$i]\n";
    }

    
}

sub usage{
    my $die =<<DIE;
    perl *.pl <DMR [dmr1,dmr2]> <context [context1,context2]> 
DIE
}
