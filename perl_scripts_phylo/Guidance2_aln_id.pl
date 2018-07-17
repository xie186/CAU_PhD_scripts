#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 4;
my ($fa, $aln, $code, $out) = @ARGV;

sub usage{
    my $die =<<DIE;
perl *.pl  <ori_fa> <aln> <code> <out> 
DIE
}

open FA, $fa or die "$!";
my %rec_codefa;
my $index = 0;
while(<FA>){
    chomp;
    next if !/^>/;
    my $tem_id = sprintf("%04d", $index);
    $tem_id = "seq".$tem_id;
    $rec_codefa{$tem_id} = $_;
    ++$index;
}
close FA;

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
open OUT, "+>$out" or die "$!";
open IN, $aln or die "$!";
my $num = 0;
my $seq_len = 0;
my %rec_seq;
while(<IN>){
    $_ =~ s/>//g;
    my ($id, $seq) = split(/\n/, $_, 2);
    my $seq_id = $rec_codefa{$rec_code{$id}};
    print "$rec_code{$id}\t$id\t$seq_id\n";
    $seq =~ s/^\n//g;
    $num ++;
    print OUT "$seq_id\n$seq";
}
close OUT;
$/ = "\n";

