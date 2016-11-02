#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==2;
my($gene,$pos)=@ARGV;

open SEQ,$gene or die "$!";
my @aa=<SEQ>;
my $join=join'',@aa;
   $join =~ s/>//;
   @aa=split(/>/,$join);
my %hash;
foreach(@aa){
    my ($name,@seq)=split(/\n/,$_);
       my $seq=join'',@seq;
       $hash{$name} = $seq;
}

my ($chr,$stt,$end) = $pos =~ /(chr\d+):(\d+)-(\d+)/;
$stt = $stt - 5000;
$end = $end + 5000;
my $seq = substr($hash{$chr}, $stt - 1, $end - $stt + 1);
print ">$pos\n$seq";
sub usage{
    my $die=<<DIE;
    perl *.pl <Gene Seq> <pos chr1:1-100>
DIE
}
