#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 3;
my ($sam_list, $dir, $geno) = @ARGV;
my @CONTEXT = ("CpG", "CHG", "CHH");
my @OTOB = ("OT", "OB");
open OUT, "+>bs_ana_sites_bed_$geno.qsub" or die "$!";
print OUT <<OUT;
#!/bin/sh -l
#PBS -q standby
#PBS -l nodes=1:ppn=16
##PBS -l naccesspolicy=shared
#PBS -l walltime=4:00:00
#PBS -N methpipe
#PBS -o bs_ana_sites_bed_$geno.out
#PBS -e bs_ana_sites_bed_$geno.err
cd \$PBS_O_WORKDIR
perl  /scratch/conte/x/xie186/perl_scripts_gong/bs_seq_gener_ana_bed.pl $sam_list $dir CpG OT bs_ana_sites_$geno\_CpG_OT.txt
perl  /scratch/conte/x/xie186/perl_scripts_gong/bs_seq_gener_ana_bed.pl $sam_list $dir CpG OB bs_ana_sites_$geno\_CpG_OB.txt 
perl  /scratch/conte/x/xie186/perl_scripts_gong/bs_seq_gener_ana_bed.pl $sam_list $dir CHG OT bs_ana_sites_$geno\_CHG_OT.txt
perl  /scratch/conte/x/xie186/perl_scripts_gong/bs_seq_gener_ana_bed.pl $sam_list $dir CHG OB bs_ana_sites_$geno\_CHG_OB.txt
perl  /scratch/conte/x/xie186/perl_scripts_gong/bs_seq_gener_ana_bed.pl $sam_list $dir CHH OT bs_ana_sites_$geno\_CHH_OT.txt
perl  /scratch/conte/x/xie186/perl_scripts_gong/bs_seq_gener_ana_bed.pl $sam_list $dir CHH OB bs_ana_sites_$geno\_CHH_OB.txt
OUT

print "qsub bs_ana_sites_bed_$geno.qsub\n";
sub usage{
    my $die =<<DIE;
perl *.pl <sam list> <dir> <geno> <cut> <out>
DIE
}
