#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==2;
my ($psl,$lef)=@ARGV;
open PSL,$psl or die "$!";
my %hash;my %hash_ge;
while(<PSL>){
    chomp;
    next if !/^\d/;
    my ($iden,$id,$len)=(split)[0,9,10];
    $hash{$id}++ if $iden/$len>=0.8;
    my ($gene)=$id=~/chr\d+_intron_\d+_\d+_(.*)/;
    $hash_ge{$gene}++ if(exists $hash{$id} && $hash{$id}>1);
}

open GE,$lef or die "$!";
while(<GE>){
    chomp;
    my ($chr,$stt,$end,$gene,$strand,$type,$te,$len)=split;
    next if $len eq "NO";
    print "$_\tsin\n" if ! exists  $hash_ge{$gene};
}


sub usage{
    my $die=<<DIE;
    perl *.pl <PSL file> <Gene>
DIE
}
