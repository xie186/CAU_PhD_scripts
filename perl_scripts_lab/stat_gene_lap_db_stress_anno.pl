#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 4;
my ($file, $var_dir, $anno, $respon) = @ARGV;

open ANNO,$anno or die "$!";
my %gene_anno;
while(<ANNO>){
    chomp;
    my ($gene,$type, $short_des) = split(/\t/, $_);
    ($gene) = split(/\./, $gene);
    $gene_anno{"$gene"} = $short_des;
}
close ANNO;

my %gene_res;
open RES, $respon or die "$!";
while(<RES>){
    chomp;
    #AT5G16970       DRASTIC:ABA-UP
    next if /^#/;
    my ($gene, $res) = split(/\t/, $_);
    $gene_res{$gene} = $res;
}
my $tot_gene_res = keys %gene_res;

open FILE, $file or die "$!";
while(<FILE>){
    next if /^#/;
    chomp;
    my ($control, $stress, $sample) = split;
    open OUT, "|sort -u >VarScan_$stress\_$control\_$sample.var.gene_anno_resStress.txt" or die "$!";
    open TEM, "cat $var_dir/VarScan_$stress\_$control.snp.Somatic.hc.fil.pass.eff.sim $var_dir/VarScan_$stress\_$control.indel.Somatic.hc.fil.pass.eff.sim |" or die "$!";
    #chr    pos     ref     alt     qual    effect  impact  gene_name       id      sample  annotation
    my (%gene_tot, %gene_res_stat);
    while(my $line = <TEM>){
         chomp $line;
         next if $line =~ /MODIFIER/; 
         my ($chr,$pos, $dot,$ref,$alt, $qual, $effect, $impact, $gene, $trans, $sample, $type, $sim_anno, $Curator_summary) = split(/\t/, $line);
         my $res = "NA";
         $res =  $gene_res{$gene} if exists $gene_res{$gene};
         $gene_res_stat{$gene} ++ if exists $gene_res{$gene};
         $gene_tot{$gene} ++;
         print OUT "$gene\t$effect\t$res\t$gene_anno{$gene}\n";
    }
    close TEM;
    my $gene_tot = keys %gene_tot;
    my $gene_res = keys %gene_res_stat;
    print "$_\t$tot_gene_res\t$gene_tot\t$gene_res\n";
}

sub usage{
    my $die =<<DIE;
    perl *.pl <file> <variation dir> <annotation> <responsive genes> 
DIE
}
