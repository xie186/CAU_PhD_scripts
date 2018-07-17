#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 3;
my ($fa, $aln, $out) = @ARGV;

sub usage{
    my $die =<<DIE;
perl *.pl  <ori_fa> <aln> <out> 
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

$/ = "\n>";
open OUT, "+>$out" or die "$!";
open IN, $aln or die "$!";
my $num = 0;
my $seq_len = 0;
my %rec_seq;
while(<IN>){
    $_ =~ s/>//g;
    my ($id, $seq) = split(/\n/, $_, 2);
    my $seq_id = $rec_codefa{$id};
    print "$id\t$seq_id\n";
    $seq =~ s/^\n//g;
    $num ++;
    print OUT "$seq_id\n$seq";
}
close OUT;
$/ = "\n";

