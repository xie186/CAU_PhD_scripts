#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 3;
my ($sam_list, $dir, $out_prefix) = @ARGV;

open OUT, "+>$out_prefix.qsub" or die "$!";
print OUT <<OUT;
#!/bin/sh -l
#PBS -q zhu132
#PBS -l nodes=1:ppn=10
#PBS -l naccesspolicy=shared
#PBS -l walltime=140:00:00
#PBS -N hypermr
#PBS -o $out_prefix.out
#PBS -e $out_prefix.err
cd \$PBS_O_WORKDIR
OUT

open SAM, $sam_list or die "$!";
while(<SAM>){
    chomp;
    print OUT <<OUT;
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
}

sub usage{
    my $die =<<DIE;
perl *.pl <sam list> <dir> <outfix>
DIE
}
