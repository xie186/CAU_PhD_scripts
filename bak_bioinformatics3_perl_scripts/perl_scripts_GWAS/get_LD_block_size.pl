#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==1;
my ($block) = @ARGV;
open LD,$block or die "$!";
my $i =1;
while(<LD>){
    chomp;
    $_ =~ s/!//g;
    my @marker = split(/\s+/,$_);
    my $block_size = $marker[-1] - $marker[0] +1;
    print "$i\t$block_size\n";
    ++ $i;
}

sub usage{
    print <<DIE;
    perl *.pl <> 
DIE
   exit 1;
}
