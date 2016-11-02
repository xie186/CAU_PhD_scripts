#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my ($deg,$go) = @ARGV;

open GO,$go or die "$!";
my %gene_go;
while(<GO>){
    chomp;
    my ($gene_id) = split;
    $gene_go{$gene_id} = $_;
}

open DEG,$deg or die "$!";
while(<DEG>){
    chomp;
    my ($chr,$stt,$end,$gene_id) = split;
    if(exists $gene_go{$gene_id}){
        print "$gene_go{$gene_id}\n";
    }
}

sub usage{
    my $die =<<DIE;
    perl *.pl <DEG> <GO> 
DIE
}
