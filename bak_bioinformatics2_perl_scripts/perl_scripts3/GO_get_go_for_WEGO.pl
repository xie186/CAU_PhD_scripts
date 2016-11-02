#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==2;
my ($all,$query)=@ARGV;
open ALL,$all or die "$!";
my %hash;
while(<ALL>){
    chomp;
    my ($name)=split;
    $hash{$name}=$_;
}

open QU,$query or die "$!";
while(<QU>){
    chomp;
    my ($chr,$stt,$end,$name)=split;
    print "$hash{$name}\n" if exists $hash{$name};
}

sub usage{
    my $die=<<DIE;
    perl *.pl <All GO> <Query GO>
DIE
}




