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
    print <<OUT;
bedtools closest -d -a cmp_$ctrl\_$treat\_exp.fisherBH.fil -b ../../raw_data/references/ara/TAIR10_GFF3_genes/TAIR10_GFF3_genes_func.bed |bedtools closest -d -a - -b ../../raw_data/references/ara/TAIR10_Transposable_Elements/TAIR10_Transposable_Elements.sim_xie.txt > cmp_$ctrl\_$treat\_exp.fisherBH.fil.anno
OUT
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
