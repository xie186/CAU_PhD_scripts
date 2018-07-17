#!/usr/bin/perl -w
use strict;
use Cwd;
my $working_dir = getcwd;

die usage() unless @ARGV ==1;
my ($pair) = @ARGV;


open PAIR, $pair or die "$!";
while(<PAIR>){
    chomp;
    my ($ctrl, $treat) = split(/\t/, $_);
    my $tot_ctrl = &getTotalRead($ctrl);
    my $tot_treat = &getTotalRead($treat);
    open OUT, "+>run_step3_cmp_$ctrl\_$treat.qsub" or die "$!";
	print OUT <<OUT;
#!/bin/sh -l
#PBS -q zhu132
#PBS -l nodes=1:ppn=1
#PBS -l walltime=244:00:00
#PBS -l naccesspolicy=shared
#PBS -N miRPlant
#PBS -o run_step3_cmp_$ctrl\_$treat.out
#PBS -e run_step3_cmp_$ctrl\_$treat.err
cd \$PBS_O_WORKDIR
#perl  ../../scripts/smRNA_clus_2sam.pl tair10_win200bp_inter24nt_smRNA_$ctrl.stat.pval,tair10_win200bp_inter24nt_smRNA_$treat.stat.pval 0.00001 > cmp_$ctrl\_$treat\_exp.txt
module load r
R --vanilla --slave --input cmp_$ctrl\_$treat\_exp.txt --tot $tot_ctrl,$tot_treat --output cmp_$ctrl\_$treat\_exp.fisherBH < ../../scripts/smRNA_clus_fisher.R 
OUT
    close OUT;
    print "qsub run_step3_cmp_$ctrl\_$treat.qsub\n";
}

sub getTotalRead{
    my ($sam) = @_;
    open IN, "smRNA_$sam\_collap.stat" or die "$!:$sam\_collap.stat";
    my $tot = 0;
    while(<IN>){
        chomp;
        my ($len, $num) = split;
        $tot += $num;
    }
    return $tot;
}

sub usage{
    my $die = <<DIE;
perl $0 input_cmp_pair
DIE
}
