#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 4;
my ($read1,$read2,$head_nu,$line) = @ARGV;

my ($test1,$test2) = ($read1,$read2);
$test1 =~ s/.gz/.test.fq/g;
$test2 =~ s/.gz/.test.fq/g;
`mkdir ./inner_size/` if !-e "./inner_size/";
system("zcat $read1 |head -$head_nu |tail -$line > ./inner_size/$test1");
system("zcat $read2 |head -$head_nu |tail -$line > ./inner_size/$test2");

`mkdir ./inner_size/` if !-e "./inner_size/";
system("bowtie -X 1000 -S /NAS1/data/bismark_index/bowtie_index/maize_pseudo_chr_bowwidx_xie -1 ./inner_size/$test1 -2 ./inner_size/$test2 > ./inner_size/$test1.sam");


sub usage{
   my $die=<<DIE;
   perl *.pl <Read1> <Read2> <head number> <tail number>
DIE
}

