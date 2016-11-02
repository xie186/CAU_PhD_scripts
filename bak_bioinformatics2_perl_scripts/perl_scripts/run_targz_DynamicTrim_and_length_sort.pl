#!/usr/bin/perl -w
use strict;

die usage() if @ARGV==0;

system qq(tar zxvf $ARGV[0]);

$ARGV[0]=~s/tar.gz/fq/;
my $fq=$ARGV[0];

system qq(perl /home/bioinformatics2/zeamxie/perl_scripts/DynamicTrim.pl -illumina $fq);

system qq(perl /home/bioinformatics2/zeamxie/perl_scripts/LengthSort.pl -l 28 $fq.trimmed);

#system qq(rm $fq.trimmed);

print "$ARGV[0] Done\n";

sub usage{
    my $die=<<DIE;
    perl *.pl <*tar.gz>
    one fastq file!
DIE
}
