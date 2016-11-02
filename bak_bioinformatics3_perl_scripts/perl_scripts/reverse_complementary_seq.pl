#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==1;
my ($fasta) = @ARGV;

open FASTA, $fasta or die "$!";
my @seq = <FASTA>;
my $seq = join('',@seq);
   $seq =~ s/>//;
   @seq = split(/>/,$seq);
foreach(@seq){
    my ($id,@tem_seq) = split(/\n/);
    my $tem_seq = join('',@tem_seq);
       $tem_seq =~ tr/ATCG/TAGC/;
       $tem_seq = reverse $tem_seq;
    print ">$id\_RC\n$tem_seq\n";
}

sub usage{
    my $die =<<DIE;
    perl *.pl <fasta> 
DIE
}
