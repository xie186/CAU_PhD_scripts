#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my($gene,$id)=@ARGV;

open SEQ,$gene or die "$!";
my @aa=<SEQ>;
my $join=join'',@aa;
   $join =~ s/>//;
   @aa=split(/>/,$join);
my %hash;
foreach(@aa){
    my ($name,@seq)=split(/\n/,$_);
    ($name) = (split(/=/,$name))[-1];
       my $seq=join'',@seq;
       $hash{$name} = $seq;
}

open NAME,$id or die "$!";
while(<NAME>){
    chomp;
    print ">$_\n$hash{$_}\n";
}
close NAME;

sub usage{
    my $die=<<DIE;
    perl *.pl <Gene Seq> <gene name>
DIE
}
