#!/usr/bin/perl -w
use strict;
my ($read1,$read2,$index_pwd,$n,$seed,$e)=@ARGV;
die usage() unless @ARGV==6;

system qq(bismark_xie $index_pwd -1 $read1 -2 $read2  --path_to_bowtie /home/bioinformatics2/software/bowtie-0.12.7/ -n $n -l $seed -e $e --chunkmbs 512 -I 50 -X 550 --directional --un $read1.ump.fq --ambiguous $read1.amb.fq);

#system qq(rm $read);
print "$read1 Doing!!!\n";


sub usage{
    my $die=<<DIE;
    perl *.pl <Read_trimmed_pair1> <Read_trimmed_pair2> <Index PWD> <Bismark -n> <Bismark -l> <Bismark -e> .NOT seperated!!!
    THIS is for updated illumina reads with no --solexa......
DIE
}
