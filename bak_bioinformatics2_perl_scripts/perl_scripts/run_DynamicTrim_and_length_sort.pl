#!/usr/bin/perl -w
use strict;

die usage() if @ARGV==0;
my ($fq1,$fq2)=@ARGV;

system qq(perl /home/bioinformatics2/zeamxie/perl_scripts/DynamicTrim.pl -illumina $fq1);
system qq(perl /home/bioinformatics2/zeamxie/perl_scripts/DynamicTrim.pl -illumina $fq2);

system qq(perl /home/bioinformatics2/zeamxie/perl_scripts/LengthSort.pl -l 28 $fq1.trimmed $fq2.trimmed);

print "$ARGV[0] Done\n";

sub usage{
    my $die=<<DIE;
    perl *.pl <Paired 1> <Paired 2>
    one fastq file!
DIE
}
