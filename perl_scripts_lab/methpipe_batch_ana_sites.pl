#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my ($sam_list, $dir) = @ARGV;

open SAM, $sam_list or die "$!";
while(<SAM>){
    chomp;
    open OUT, "+>gener_hypermr_$_.qsub" or die "$!";
    print OUT <<OUT;
#!/bin/sh -l
#PBS -q standby
#PBS -l nodes=1:ppn=16
##PBS -l naccesspolicy=shared
#PBS -l walltime=4:00:00
#PBS -N methpipe
#PBS -o gener_hypermr_$_.out
#PBS -e gener_hypermr_$_.err
cd \$PBS_O_WORKDIR

#CpG
awk '{\$5=1-\$5;print \$0}' $dir/bed_$_\_CpG.meth > $dir/bed_$_\_CpG_inverted.meth
/scratch/conte/x/xie186/software/methpipe/bin/hmr -o $dir/bed_$_\_CpG.hypermeth $dir/bed_$_\_CpG_inverted.meth
/scratch/conte/x/xie186/software/methpipe/bin/hypermr -o $dir/bed_$_\_CpG.hypermr  $dir/bed_$_\_CpG.meth
#CXX
awk '{\$5=1-\$5;print \$0}' $dir/bed_$_\_CXX.meth > $dir/bed_$_\_CXX_inverted.meth
/scratch/conte/x/xie186/software/methpipe/bin/hmr -o $dir/bed_$_\_CXX.hypermeth $dir/bed_$_\_CXX_inverted.meth
/scratch/conte/x/xie186/software/methpipe/bin/hypermr -o $dir/bed_$_\_CXX.hypermr  $dir/bed_$_\_CXX.meth
#CHH
awk '{\$5=1-\$5;print \$0}' $dir/bed_$_\_CHH.meth > $dir/bed_$_\_CHH_inverted.meth
/scratch/conte/x/xie186/software/methpipe/bin/hmr -o $dir/bed_$_\_CHH.hypermeth $dir/bed_$_\_CHH_inverted.meth
/scratch/conte/x/xie186/software/methpipe/bin/hypermr -o $dir/bed_$_\_CHH.hypermr  $dir/bed_$_\_CHH.meth
#CHG
awk '{\$5=1-\$5;print \$0}' $dir/bed_$_\_CHG.meth > $dir/bed_$_\_CHG_inverted.meth
/scratch/conte/x/xie186/software/methpipe/bin/hmr -o $dir/bed_$_\_CHG.hypermeth $dir/bed_$_\_CHG_inverted.meth
/scratch/conte/x/xie186/software/methpipe/bin/hypermr -o $dir/bed_$_\_CHG.hypermr  $dir/bed_$_\_CHG.meth
OUT
    print "qsub gener_hypermr_$_.qsub\n";
}

sub usage{
    my $die =<<DIE;
perl *.pl <sam list> <dir> 
DIE
}
