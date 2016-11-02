#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==2;
my($gene,$imp)=@ARGV;

open SEQ,$gene or die "$!";
my @aa=<SEQ>;
my $join=join'',@aa;
   @aa=split(/>/,$join);
my %hash;
foreach(@aa){
    my ($name,@seq)=split(/\n/,$_);
    if($name && @seq){
       ($name)=split(/\s+/,$name); 
       my $seq=join'',@seq;
       $hash{$name}=$_;
    }
}

open IMP,$imp or die "$!";
while(<IMP>){
    chomp;
    if(exists $hash{$_}){
        print ">$hash{$_}\n";
    }
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Gene Seq> <Imp>
DIE
}
