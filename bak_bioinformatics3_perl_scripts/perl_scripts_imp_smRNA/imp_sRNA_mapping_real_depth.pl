#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 1;
my ($fa) = @ARGV;
open FA,$fa or die "$!";
while(my $name = <FA>){
    chomp $name;
    my $seq = <FA>;
    my ($id,$len,$nu) = split(/_/,$name);
    for(my $i = 1;$i <= $nu; ++$i){
        print "$name\_$i\n$seq";
    }
}

sub usage{
    print <<DIE;
    perl *.pl <FASTA> 
DIE
    exit 1;
}
