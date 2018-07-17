#!/usr/bin/perl -w
use strict;

my ($fq, $out) = @ARGV;
open FQ, $fq or die "$!";
my %rec_seq;
while(my $line = <FQ>){
    my $seq = <FQ>;
    chomp $seq;
    <FQ>;
    <FQ>;
    $rec_seq{$seq} ++;
}
close FQ;

open OUT, "+>$out" or die "$!";
my %stat_smRNA;
my $rec_acc = 0;
foreach(keys %rec_seq){
    $rec_acc++;
    my $len = length $_;
    next if ($len > 28 || $len < 18);
    my $num = $rec_seq{$_};
    my $fix_rec_acc = sprintf("%08d", $rec_acc);
    print OUT ">$fix_rec_acc\_$len\_$num\n$_\n";
    $stat_smRNA{$len} += $num;
}
close OUT;

foreach(sort keys %stat_smRNA){
    print "$_\t$stat_smRNA{$_}\n";
}


