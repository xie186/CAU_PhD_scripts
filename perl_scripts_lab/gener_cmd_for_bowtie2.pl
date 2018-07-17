#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 3;
my ($file, $work_dir, $queue) = @ARGV;

open FILE, $file or die "$!";
while(<FILE>){
    next if /^#/;
    my ($acc, $type, $geno,$generation, $stress, $date, $dir) = split;
    my @read1 = <$dir/*R1*gz>;
    my @read2 = <$dir/*R2*gz>;
    my $num = @read1;
    open TEM, "+>$type\_$geno\_$generation\_$stress\_$date.qsub" or die "$!";
    if($num == 1){
         my $read1 = $read1[0];
         my $read2 = $read2[0];
         print TEM <<OUT;
#!/bin/sh -l
#PBS -q $queue
#PBS -l walltime=04:00:00
#PBS -l nodes=1:ppn=16
#PBS -N bwa_align
#PBS -d $work_dir
#PBS -o $type\_$geno\_$generation\_$stress\_$date.out
#PBS -e $type\_$geno\_$generation\_$stress\_$date.err
#\$CLUSTER_SCRATCH/software/bwa-0.7.10/bwa mem -t 16 -R "\@RG\\tID:$acc\\tPL:ILLUMINA\\tLB:$acc\\tSM:$acc" \$CLUSTER_SCRATCH/data/ara/TAIR10_chr_all.bwaidx $read1 $read2 |samtools view -bS - |samtools sort - $type\_$geno\_$generation\_$stress\_$date\_srt 
samtools index $type\_$geno\_$generation\_$stress\_$date\_srt.bam
OUT
    }else{
        my $read1 = join(" ", @read1);
        my $read2 = join(" ", @read2);
        print TEM <<OUT;
#!/bin/sh -l
#PBS -q $queue
#PBS -l walltime=04:00:00
#PBS -l nodes=1:ppn=16
#PBS -N bwa_align
#PBS -d $work_dir
#PBS -o $type\_$geno\_$generation\_$stress\_$date.out
#PBS -e $type\_$geno\_$generation\_$stress\_$date.err
zcat $read1 > $type\_$geno\_$generation\_$stress\_$date\_R1.fq
zcat $read2 > $type\_$geno\_$generation\_$stress\_$date\_R2.fq
#\$CLUSTER_SCRATCH/software/bwa-0.7.10/bwa mem -t 16 -R "\@RG\\tID:$acc\\tPL:ILLUMINA\\tLB:$acc\\tSM:$acc" \$CLUSTER_SCRATCH/data/ara/TAIR10_chr_all.bwaidx $type\_$geno\_$generation\_$stress\_$date\_R1.fq $type\_$geno\_$generation\_$stress\_$date\_R2.fq |samtools view -bS - |samtools sort - $type\_$geno\_$generation\_$stress\_$date\_srt
samtools index $type\_$geno\_$generation\_$stress\_$date\_srt.bam
OUT
    }
    print "qsub $type\_$geno\_$generation\_$stress\_$date.qsub\n";
    close TEM;
}
close FILE;

sub usage{
my $die =<<DIE;
perl *.pl <File List> <working directory> <queues> 
DIE
}

