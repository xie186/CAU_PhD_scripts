#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==2;
my ($anno, $deg) = @ARGV;
open ANNO,$anno or die "$!";
my %anno;
while(<ANNO>){
    chomp;
    my ($id,$gene,$trans,$prot, $func) = split(/\t/, $_, 5);
    $anno{$gene} = $func;
}
close ANNO;

open DEG,$deg or die "$!";
while(<DEG>){
    chomp;
    my ($chr,$stt,$end,$gene) = split;
    if(!/^chr/){
        print "$_\n";
    }else{
        print "$_\t$anno{$gene}\n";
    }
}

sub usage{
    my $die =<<DIE;
    perl *.pl <ANNO> <DEG> 
DIE
}
