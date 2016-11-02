#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==2;
my($gene,$name)=@ARGV;

open NAME,$name or die "$!";
my %hash_name;
while(<NAME>){
    chomp;
    $hash_name{$_}++;
}

open SEQ,$gene or die "$!";
my @aa=<SEQ>;
my $join=join'',@aa;
   @aa=split(/>/,$join);
shift @aa;
my %hash;
foreach(@aa){
    my ($name,@seq)=split(/\n/,$_);
    my $seq=join'',@seq;
    foreach my $tem_gene(keys %hash_name){
        print ">$name\n$seq\n" if $name =~ /$tem_gene/;
    }
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Gene Seq> <gene name>
DIE
}
