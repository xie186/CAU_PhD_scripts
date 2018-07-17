#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 3;
my ($in, $code, $out) = @ARGV;

sub usage{
    my $die =<<DIE;
perl *.pl <in> <code> <out> 
DIE
}

open CODE, $code or die "$!";
my %rec_code;
while(<CODE>){
    chomp;
    #seq0086 12 
    my ($acc, $aln_id) = split;
    $rec_code{$aln_id} = $acc;
}
close CODE;

$/ = "\n>";
open IN, $in or die "$!";
my $num = 0;
my $seq_len = 0;
my %rec_seq;
while(<IN>){
    $_ =~ s/>//g;
    my ($id, $seq) = split(/\n/, $_, 2); 
    $seq =~ s/\n//g;
    $seq_len = length $seq;
    my $acc = $rec_code{$id};
    $rec_seq{$acc} = $seq;
    $num ++;
}
$/ = "\n";

open OUT, "+>$out" or die "$!";
print OUT "$num $seq_len\n";
foreach(keys %rec_seq){
    print OUT "$_ $rec_seq{$_}\n";
}
close OUT;
