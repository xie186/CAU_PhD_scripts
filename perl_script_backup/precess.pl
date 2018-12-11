#!/usr/bin/perl -w
use strict;
my @files=("en1_1.sam","en1_2.sam");

#foreach my $file(@files){
#	print "doing $files[0]\n";
	my ($base1)=$files[0]=~/(.*)\.sam/;
	my $sort1=$base1."_sort";
	my $bam_sort1=$base1."_sort.bam";

#	print "view and sort,make $sort1\n";
#	system "samtools view -uS -q 1  $files[0] | samtools sort - $sort1";


#	print "doing $files[1]\n";
	my ($base2)=$files[1]=~/(.*)\.sam/;
	my $sort2=$base2."_sort";
	my $bam_sort2=$base2."_sort.bam";

#	print "view and sort,make $sort2\n";
#	system "samtools view -uS -q 1  $files[1] | samtools sort - $sort2";

	print "merge $bam_sort1 $bam_sort2\n";

#samtools merge [-nr] [-h inh.sam] <out.bam> <in1.bam> <in2.bam> [...]
	system "samtools merge -n -h $files[0] en1.bam $bam_sort1 $bam_sort2";
#	print "sort,make $bam_sort\n";
	system "samtools sort en1.bam en1_sort";

	print "index\n";
	system "samtools index en1_sort.bam";

	print "pileup,make en1.pileup\n";
	system "samtools pileup -cf ~/data/pseudochromosome/maize.fa en1_sort.bam > en1.pileup";
