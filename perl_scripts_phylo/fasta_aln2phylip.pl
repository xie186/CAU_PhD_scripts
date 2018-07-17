#!/usr/bin/perl -w
use strict;

my ($in, $out) = @ARGV;

die usage() unless @ARGV ==2;
sub usage{
    my $die =<<DIE;
perl *.pl <in> <out> 
DIE
}
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
    my $tem_id = sprintf("%08d", $num);
    $rec_seq{$tem_id} = $seq;
    $num ++;
    print "$tem_id\t$id\n";
}
$/ = "\n";

open OUT, "+>$out" or die "$!";
print OUT "$num $seq_len\n";
foreach(keys %rec_seq){
    print OUT "$_ $rec_seq{$_}\n";
}
close OUT;
