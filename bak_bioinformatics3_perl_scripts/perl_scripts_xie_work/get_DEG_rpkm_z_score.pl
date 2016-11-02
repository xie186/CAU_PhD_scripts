#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==2;
my ($z_score,$gene) = @ARGV;
open SCORE,$z_score or die "$!";
my $header = <SCORE>;
print "$header";
my %hash_score;
while(<SCORE>){
    chomp;
    my ($gene_id) = split;
    $hash_score{$gene_id} = $_;
}

open GE,$gene or die "$!";
while(<GE>){
    chomp;
    print "$hash_score{$_}\n";
}

sub usage{
    my $die =<<DIE;
    perl *.pl <z_score> <gene> 
DIE
}
