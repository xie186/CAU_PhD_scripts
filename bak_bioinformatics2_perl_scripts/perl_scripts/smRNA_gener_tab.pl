#!/usr/bin/perl -w
use strict;
my ($sam)=@ARGV;
die usage() unless @ARGV==1;
open SAM,$sam or die "$!";
while(<SAM>){
    chomp;
    next if /@/;
    my ($name,$strand,$chr,$pos)=split;
    my ($id,$len,$copy)=$name=~/t(\d+)_(\d+)_(\d+)/;
    print "$id\t$len\t$copy\t$strand\t$chr\t$pos\n" if $chr=~/^chr/;
}

sub usage{
    my $die=<<DIE;
    perl *.pl <SAM file>  >>OUT
DIE
}
