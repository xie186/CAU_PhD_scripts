#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my ($sam_list, $dir) = @ARGV;

open SAM, $sam_list or die "$!";
while(<SAM>){
    chomp;
    my ($wt, $mut) = split;
    open OUT, "+>gener_DMR_$wt\_$mut.qsub" or die "$!";
    print OUT <<OUT;
#!/bin/sh -l
#PBS -q standby
#PBS -l nodes=1:ppn=16
#PBS -l naccesspolicy=shared
#PBS -l walltime=4:00:00
#PBS -N methpipe_DMR
#PBS -o gener_DMR_$wt\_$mut.out
#PBS -e gener_DMR_$wt\_$mut.err
cd \$PBS_O_WORKDIR

#CpG
/scratch/conte/x/xie186/software/methpipe/bin/methdiff -o bed_$wt\_$mut\_CpG.methdiff $dir/bed_$wt\_CpG.meth $dir/bed_$mut\_CpG.meth
/scratch/conte/x/xie186/software/methpipe/bin/dmr bed_$wt\_$mut\_CpG.methdiff $dir/bed_$wt\_CpG.hypermr $dir/bed_$mut\_CpG.hypermr DMR_$wt\_$mut\_CpG_hypo.txt DMR_$wt\_$mut\_CpG_hyper.txt

#CHG
/scratch/conte/x/xie186/software/methpipe/bin/methdiff -o bed_$wt\_$mut\_CHG.methdiff $dir/bed_$wt\_CHG.meth $dir/bed_$mut\_CHG.meth
/scratch/conte/x/xie186/software/methpipe/bin/dmr bed_$wt\_$mut\_CHG.methdiff $dir/bed_$wt\_CHG.hypermr $dir/bed_$mut\_CHG.hypermr DMR_$wt\_$mut\_CHG_hypo.txt DMR_$wt\_$mut\_CHG_hyper.txt

#CHH
/scratch/conte/x/xie186/software/methpipe/bin/methdiff -o bed_$wt\_$mut\_CHH.methdiff $dir/bed_$wt\_CHH.meth $dir/bed_$mut\_CHH.meth
/scratch/conte/x/xie186/software/methpipe/bin/dmr bed_$wt\_$mut\_CHH.methdiff $dir/bed_$wt\_CHH.hypermr $dir/bed_$mut\_CHH.hypermr DMR_$wt\_$mut\_CHH_hypo.txt DMR_$wt\_$mut\_CHH_hyper.txt

#CpG
/scratch/conte/x/xie186/software/methpipe/bin/methdiff -o bed_$wt\_$mut\_CXX.methdiff $dir/bed_$wt\_CXX.meth $dir/bed_$mut\_CXX.meth
/scratch/conte/x/xie186/software/methpipe/bin/dmr bed_$wt\_$mut\_CXX.methdiff $dir/bed_$wt\_CXX.hypermr $dir/bed_$mut\_CXX.hypermr DMR_$wt\_$mut\_CXX_hypo.txt DMR_$wt\_$mut\_CXX_hyper.txt

OUT
    print "qsub gener_DMR_$wt\_$mut.qsub\n";
}

sub usage{
    my $die =<<DIE;
perl *.pl <sam list> <dir> 
DIE
}
