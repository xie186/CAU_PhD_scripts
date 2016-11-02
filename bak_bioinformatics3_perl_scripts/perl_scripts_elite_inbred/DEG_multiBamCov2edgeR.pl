#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 3;
my ($bam_cov,$file_header,$depth_cut) = @ARGV;
my @header = split(/,/,$file_header);
my $header = join("\t",@header);
#print "gene_id\t$header\n";
print "gene_id\t$header\tlen\n";
open COV,"$bam_cov" or die "$!";
while(<COV>){
    chomp;
    my ($chr,$stt,$end,$gene,$strand,@depth) = split;
    my $len = $end - $stt + 1;
    my $sum = &sum_depth(\@depth);
    next if $sum < $depth_cut;
    for(my $i = 0;$i < @depth; ++$i){
        $depth[$i] += 1;
    }
    my $depth = join("\t",@depth);
    print "$gene\t$depth\t$len\n";
}

sub sum_depth{
    my ($depth) = @_;
    my $sum = 0;
    foreach(@$depth){
        $sum += $_;
    }
    return $sum;
}

sub usage{
    my $die =<<DIE;
    perl *.pl <bam cov res> <file header [1,2,3]> <depth cut>
DIE
}
