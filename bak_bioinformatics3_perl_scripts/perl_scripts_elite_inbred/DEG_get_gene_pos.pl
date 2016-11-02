#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==2;
my ($pos,$deg) = @ARGV;
open POS, $pos or die "$!";
my %gene_pos;
while(<POS>){
    chomp;
    my ($chr,$stt,$end,$gene_id,$strand) = split;
    $gene_pos{$gene_id} = $_;
}

open DEG,$deg or die "$!";
while(<DEG>){
    chomp;
    my ($gene_id,$log_chg) = split(/\t/);
    print "$gene_pos{$gene_id}\t$log_chg\n";
}

sub usage{
    my $die =<<DIE;
    perl *.pl <position> <DEG> 
DIE
}
