#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==1;
my ($cdna)=@ARGV;

open CDNA,$cdna or die "$!";

my @tem=<CDNA>;
my $mid=join'',@tem;
   @tem=split(/>/,$mid);
   $mid=0;

my %hash;
foreach(@tem){
    next if ! $_;
    my @seq=split(/\n/,$_);
    chomp @seq;
    my $name=shift @seq;
       ($name)=(split(/parent_gene=/,$name))[-1];
    my $sequ=join'',@seq;
    my $len=length $sequ;
    if(exists $hash{$name} && $len<$hash{$name}){
        next;
    }else{
        $hash{$name}=$len;
    }
}

foreach(keys %hash){
    print "$_\t$hash{$_}\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <cDNA> 
DIE
}
