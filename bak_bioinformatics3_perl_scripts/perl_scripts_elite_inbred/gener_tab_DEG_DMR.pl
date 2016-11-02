#!/usr/bin/perl -w
use strict;

my ($diff, $IBD, $all_gene) = @ARGV;
my $deg_IBD = `awk '$5=="q1" && $6 == "q4"' /NAS1/zeamxie/methylome_elite_lines/elite_inbreds_RNAseq_libChen/elite_inbreds_RNAseq_cuffdiff_g20/gene_exp.diff |grep 'yes' |perl -e 'while(<>){@aa=split;($chr,$stt,$end)=$aa[3]=~/(chr\d+):(\d+)-(\d+)/;print "$chr\t$stt\t$end\t$aa[2]\n";}' |intersectBed -a - -b ../../../elite_inbreds_SNP_xie/z58/IBD_z58_win_478_region_perfect.bed  |wc -l`;
