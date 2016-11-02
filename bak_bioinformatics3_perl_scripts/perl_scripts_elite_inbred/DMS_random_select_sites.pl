#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 3;
my ($dms, $cutoff, $process) = @ARGV;
open DMS,$dms or die "$!";
my $dms_num = 0;
my @all_sites;
while(<DMS>){
    chomp;
    my ($chr,$stt,$end,$c1,$t1,$c2,$t2,$lev1,$lev2,$diff,$pval,$qval) = split;
    if($qval < $cutoff){
        print "$chr\t$stt\t$end\t$process\n";
        ++ $dms_num;
    }
    push @all_sites, "$chr\t$stt\t$end\tRandom\_$process";
}

my $tot_num = @all_sites;
for(my $i = 0; $i < $dms_num; ++$i){
    my $rand = int(rand($tot_num)); 
    print "$all_sites[$rand]\n";
}

sub usage{
    my $die =<<DIE;
    perl *.pl <DMS> <cutoff> <process>
DIE
}
