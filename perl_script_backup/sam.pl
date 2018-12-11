#!/usr/bin/perl -w

print "view\n";
system "samtools view -bS -q 10 en1.sam en1.bam";

print "sort\n";

system "samtools sort en1.bam en1_sort";

print "index\n";
system "samtools index en1_sort.bam";


print "pileup\n";
system "samtools pileup -f ~/
