#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==2;
my ($fgs,$tab) = @ARGV;
open FGS,$fgs or die "$!";
my %hash_fgs;
while(<FGS>){
    chomp;
    my ($chr,$stt,$end,$gene_id,$strand) = split;
    $hash_fgs{$gene_id} ++;
}

open TAB,$tab or die "$!";
while(<TAB>){
    chomp;
    my ($chr,$pos,$gene) = split;
#    print "$gene\n" if !exists $hash_fgs{$gene} ;
    next if (!exists $hash_fgs{$gene} && $gene !~ /chr/);
    print "$_\n";
}

sub usage{
    my $die =<<DIE;
    perl *.pl <FGS> <tab>
DIE
}
