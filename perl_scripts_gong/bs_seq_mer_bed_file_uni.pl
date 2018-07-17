#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 5;
sub usage{
    my $die =<<DIE;
perl *.pl <sample list> <directory> <prefix> <surfix> <geno len>
DIE
}
my ($sam_list, $dir, $prefix, $surfix, $geno_len) = @ARGV;
#my @context = ("CpG", "CHG", "CHH");
my @context = ("CXX");

open SAM, $sam_list or die "$!";
while(my $sample = <SAM>){
    #chr1    10000002        0       15      0
    chomp $sample;
    ($sample) = split(/\s+/, $sample);
    foreach my $context (@context){
        &out_bedgraph($sample, $context);
    } 
}

sub out_bedgraph{
    my ($sample, $context) = @_;
    open OUT, "|sort -u -k1,1 -k2,2n > $prefix\_$sample\_$context.$surfix" or die "$!";
    open OT, "zcat $dir/bed_$context\_OT_$sample.txt.gz |" or die "$!";
    while(<OT>){
        my ($chr, $pos, $c_num, $depthi, $lev) = split;
        my $end = $pos + 1;
        print OUT "$chr\t$pos\t$end\t$lev\n";
    }
    close OT;
   
    open OB, "zcat $dir/bed_$context\_OB_$sample.txt.gz |" or die "$!";
    while(<OB>){
        my ($chr, $pos, $c_num, $depthi, $lev) = split;
        my $end = $pos + 1;
        print OUT "$chr\t$pos\t$end\t-$lev\n";
    }
    close OB;
    close OUT;
    `/scratch/conte/x/xie186/software/irap-7f0750d3a1fe/download/bedGraphToBigWig $prefix\_$sample\_$context.$surfix $geno_len $prefix\_$sample\_$context.bw`;
}
