#!/usr/bin/perl -w
use strict;
my ($index, $read, $read_format ,$proc, $out) = @ARGV;
die usage() unless @ARGV == 5;

my $log;
if($read_format eq "sanger"){
    $log = `bwa aln -q 13 -t $proc $index $read | bwa samse $index - $read | samtools view -bS - | samtools sort - $out.srt`;
}elsif($read_format eq "illumina"){
    $log = `bwa aln -I -q 13 -t $proc $index $read | bwa samse $index - $read | samtools view -bS - | samtools sort - $out.srt`;
}


sub usage{
    print <<DIE;
    perl *.pl <index> <read> <"sanger" or "illumina"> <CPU number> <out> 
DIE
    exit 1;
}
