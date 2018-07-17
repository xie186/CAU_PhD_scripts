#!/usr/bin/perl -w
use strict;

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
zcat $input_fq |../../softwares/fastx_toolkit-0.0.13.2/bin/fastx_clipper -v -a TGGAATTCTCGGGTGCCAAGG -Q 33 -i - -o $sam_name\_trim.fq
perl ../../perl_scripts/smRNA_fq2fa_for_miRPlant.pl $sam_name\_trim.fq $sam_name\_trim.fa
java -jar miRPlant_command_line.jar -g TAIR9 $sam_name\_trim.fa

OUT

sub usage{
    my $die = <<DIE;
perl $0 input_fq sam_name 
DIE
}
