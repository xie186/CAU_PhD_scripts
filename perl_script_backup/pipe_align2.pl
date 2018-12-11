#!/usr/bin/perl -w
#print "donging en3_1\n";
#system "bowtie -S -k 1 --best -n 2 -e 80 -p 4 --chunkmbs=1024 ~/data/pseudochromosome/maize_pseudo en3_L1_1_q33.fq en3_1.sam";


#print "donging en3_2\n";
#system "bowtie -S -k 1 --best -n 2 -e 80 -p 4 --chunkmbs=1024 ~/data/pseudochromosome/maize_pseudo en3_L1_2_q33.fq en3_2.sam";

#print "merge\n";
#print "\tview\n";
#system "samtools view -uS -q 1 en3_1.sam | samtools sort - en3_1_sort";

#system "samtools view -uS -q 1 en3_2.sam | samtools sort - en3_2_sort";

#print "\tmerge\n";
#system "samtools merge -h en3_1.sam en3.bam en3_1_sort.bam en3_2_sort.bam";
#print "\tsort\n";
#system "samtools sort en3.bam en3_sort";

#system "samtools index en3_sort.bam";


print "donging en4_1\n";

system "bowtie -S -k 1 --best -n 2 -e 80 -p 4 --chunkmbs=1024 ~/data/pseudochromosome/maize_pseudo en4_L1_1_q33.fq en4_1.sam";

print "donging en4_2\n";

system "bowtie -S -k 1 --best -n 2 -e 80 -p 4 --chunkmbs=1024 ~/data/pseudochromosome/maize_pseudo en4_L1_2_q33.fq en4_2.sam";


print "merge\n\tview\n";
system "samtools view -uS -q 1 en4_1.sam | samtools sort - en4_1_sort";
system "samtools view -uS -q 1 en4_2.sam | samtools sort - en4_2_sort";

print "\tmerge\n";
system "samtools merge -h en4_1.sam en4.bam en4_1_sort.bam en4_2_sort.bam";
print "\tsort\n";
system "samtools sort en4.bam en4_sort";

system "samtools index en4_sort.bam";

