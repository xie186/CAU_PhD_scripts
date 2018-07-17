#!/usr/bin/perl -w
use strict;
use Cwd;
my $working_dir = getcwd;

die usage() unless @ARGV ==2;
my ($input_fq, $sam_name) = @ARGV;


print <<OUT;
#!/bin/sh -l
#PBS -q zhu132
#PBS -l nodes=1:ppn=4
#PBS -l walltime=244:00:00
#PBS -l naccesspolicy=shared
#PBS -N miRPlant
#PBS -o run_step1_miRNAPlant_$sam_name.out
#PBS -e run_step1_miRNAPlant_$sam_name.err
cd \$PBS_O_WORKDIR
#zcat $input_fq |../../softwares/fastx_toolkit-0.0.13.2/bin/fastx_clipper -v -a TGGAATTCTCGGGTGCCAAGG -Q 33 -i - -o $sam_name\_trim.fq
perl ../../scripts/smRNA_fq2fa4cluster.pl $sam_name\_trim.fq $sam_name\_collap.fa > $sam_name\_collap.stat
#../../softwares/bowtie-1.1.1/bowtie --sam -f -v 0 -m 1 ../../raw_data/references/ara/TAIR10_chr_all.fasta $sam_name\_collap.fa | ../../softwares/samtools-1.2/bin/samtools view -bS - |../../softwares/samtools-1.2/bin/samtools sort - $sam_name\_bow.sorted

export PATH=\$PATH:$working_dir/softwares/BEDTools-2.25.0/bin/
#bamToBed -i $sam_name\_bow.sorted.bam |intersectBed -a TAIR10_chr_all.win200bp.txt -b - -wa -wb  > tair10_win200bp_intersect_$sam_name.txt
#perl ../../scripts/smRNA_stat_win_24nt_non_ident.pl TAIR10_chr_all.win200bp.txt tair10_win200bp_intersect_$sam_name.txt |sort -k1,1 -k2,2n  > tair10_win200bp_inter24nt_$sam_name.stat
#module load r
#R --vanilla --slave --input tair10_win200bp_inter24nt_$sam_name.stat --output tair10_win200bp_inter24nt_$sam_name.stat.pval  < ../../scripts/smRNA_cluster_pois.R
OUT

sub usage{
    my $die = <<DIE;
perl $0 input_fq sam_name 
DIE
}
