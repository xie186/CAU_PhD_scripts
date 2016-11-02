#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==2;
my ($ge_wthout_te,$ge_wthout_intron_te)=@ARGV;
open GE,$ge_wthout_te or die "$!";
my %hash;
while(<GE>){
    chomp;
    my ($chr,$stt,$end,$gene,$strand)=split;
    $hash{$gene}++;
}

open NT,$ge_wthout_intron_te or die "$!";
while(<NT>){
    chomp;
#    my ($chr,$ele,$stt1,$end1,$strand,$name,$rpkm)=(split)[0,2,3,4,6,8,9];
    my ($name)=(split)[3];
    print "$_\n" if exists $hash{$name};
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Genes without annotated TEs within gene region> <Genes without introns with TE insertion >
DIE
}
