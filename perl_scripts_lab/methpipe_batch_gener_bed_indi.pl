#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my ($sam_list, $dir) = @ARGV;

open SAM, $sam_list or die "$!";
while(<SAM>){
    chomp;
    open OUT, "+>gener_bed_$_.qsub" or die "$!";
    print OUT <<OUT;
#!/bin/sh -l
#PBS -q standby
#PBS -l nodes=1:ppn=16
##PBS -l naccesspolicy=shared
#PBS -l walltime=4:00:00
#PBS -N methpipe
#PBS -o gener_bed_$_.out
#PBS -e gener_bed_$_.err
cd \$PBS_O_WORKDIR

perl /scratch/conte/x/xie186/perl_scripts_lab/methpipe_gener_bed_file.pl $dir/bed_CpG_OT_$_.txt.gz,$dir/bed_CpG_OB_$_.txt.gz 3 CpG |sort -k1,1 -k2,2n > bed_$_\_CpG.meth 
perl /scratch/conte/x/xie186/perl_scripts_lab/methpipe_gener_bed_file.pl $dir/bed_CHG_OT_$_.txt.gz,$dir/bed_CHG_OB_$_.txt.gz 3 CHG |sort -k1,1 -k2,2n > bed_$_\_CHG.meth
perl /scratch/conte/x/xie186/perl_scripts_lab/methpipe_gener_bed_file.pl $dir/bed_CHH_OT_$_.txt.gz,$dir/bed_CHH_OB_$_.txt.gz 3 CHH |sort -k1,1 -k2,2n > bed_$_\_CHH.meth
cat bed_$_\_CpG.meth bed_$_\_CHG.meth bed_$_\_CHH.meth |sort -k1,1 -k2,2n > bed_$_\_CXX.meth
OUT
    print "qsub gener_bed_$_.qsub\n";
}

sub usage{
    my $die =<<DIE;
perl *.pl <sam list> <dir> 
DIE
}
