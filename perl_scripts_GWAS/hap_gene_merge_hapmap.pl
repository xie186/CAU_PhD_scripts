#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV ==2;
my ($hapmap_pre,$hapmap_nu) = @ARGV;

open HEAD,$hapmap_pre."1.hapmap" or die "$!";
my $head = <HEAD>;
print "$head";

for(my $i=1;$i <= $hapmap_nu;++$i){
    my $name = $hapmap_pre."$i".".hapmap";
    open HAP,$name or die "$!";
    my $tem_head = <HAP>;
    while(<HAP>){
        print "$_";
    }
}

sub usage{
    my $die=<<DIE;  
    perl *.pl <hapmap prefix> <number>
DIE
}
