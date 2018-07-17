#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==2;
my ($fq, $out) = @ARGV;
open FQ, $fq or die "$!";
my %rec_seq;
while(my $line = <FQ>){
    my $seq = <FQ>;
    chomp $seq;
    #$seq =~ tr/T/U/;
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
    next if ($len > 30 || $len < 18);
    my $num = $rec_seq{$_};
    my $fix_rec_acc = sprintf("%08d", $rec_acc);
    print OUT ">t$rec_acc	$num\n$_\n";
    $stat_smRNA{$len} += $num;
}
close OUT;

foreach(sort keys %stat_smRNA){
    print "$_\t$stat_smRNA{$_}\n";
}

sub usage{
    my $die =<<DIE;
perl $0 <fastq > <output fasta> 
DIE
}

