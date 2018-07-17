#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 2;
my ($file, $prefix) = @ARGV;
open FILE, $file or die "$!";
while(<FILE>){
    next if /^#/;
    chomp;
    my ($label, $type, $geno,$generation, $stress, $date) = split;
    my @dir = <$prefix/$date/*$label\_*/>;
    my $dir = join(",", @dir);
    print "$_\t$dir\n";
#    print <<OUT;
#/Users/jkzhu/zeamxie/software/bowtie2-2.2.3/bowtie2 -x ~/zeamxie/data/ara/TAIR10_chr_all.fasta -1 $read1 -2 $read2 |samtools view -bS - |samtools sort - $type\_$geno\_$generation\_$stress\_$date\_srt &
#OUT
}

sub usage{
my $die =<<DIE;
perl *.pl <File List> <dir prefix>
DIE
}

