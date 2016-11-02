#!/usr/bin/perl -w
use strict;

die "perl *.pl <region> <fasta> <out1> <out2>\n" unless @ARGV ==4;
my ($region, $fasta, $out1, $out2)  = @ARGV;

open OUT1, "+>$out1" or die "$!";
open OUT2, "+>$out2" or die "$!";
$/ = "\n>";
open FA,$fasta or die "$!";
while(<FA>){
    $_=~s/>//g;
    my ($chrom, @seq) = split;
    chomp @seq;
    my $seq = join("", @seq);
    local $/ = "\n";
    open REG, $region or die "$!";
    while(my $line = <REG>){
        chomp $line;
        my ($chr, $stt, $end) = split(/\t/, $line);
        next if $chrom ne $chr;
        $stt = $stt * 1000000;
        $end = $end * 1000000;
        my $sub1 = substr($seq, $stt - 1, 500);
        my $sub2 = substr($seq, $end - 501, 500);
           $sub2 = reverse $sub2;
           $sub2 =~ tr/ATGC/TACG/;
        my $print1 = &print($chr, $stt, $end, $sub1, 1);
        my $print2 = &print($chr, $stt, $end, $sub2, 2); 
        print OUT1 $print1;
        print OUT2 $print2;
    }

}
close FA;

sub print{
    my ($chr,$stt,$end, $seq, $num) = @_;
    my @read;
    push @read, "\@$chr\_$stt\_$end#/$num\n";
    push @read, "$seq\n";
    push @read, "+\n";
    $seq =~ tr/ATGCN/I/;
    push @read, "$seq\n";
    my $read = join('',@read);
    return $read;
}
