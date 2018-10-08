#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 4;
my ($region, $deep_seq, $ref, $bam_pwd) = @ARGV;
open DEEP,$deep_seq or die "$!";
my %hash_inbred;
my $opt_c = "target_bam_file.txt";
open OPT,"+>$opt_c" or die "$!";
print OPT "#names	no.haploids	no.samples	mq	bq\n";
while(<DEEP>){
    chomp;
    next if /##/;
    my ($cau_acc,$inbred) = split;
    $hash_inbred{$cau_acc} = $inbred;
    print OPT "$cau_acc.sorted.picard.bam\t2\t1\t20\t13\n";
}

open REG,$region or die "$!";
my $gene_region = "target_region.txt";
open TEM, "+>$gene_region" or die "$!";
while(<REG>){
    chomp;
    my ($chr,$stt,$end,$gene) = split;
       ($stt,$end) = ($stt - 2000,$end + 2000);
    print TEM "chr$chr\t$stt\t$end\t$gene\n"; 
}

print "java -jar /NAS1/software/SNVerPool.jar -i /NAS2/GWAS_bam_file/bam_file_totoal/ -r /NAS1/data/pseudochromosome/maize_pseudo_chr.fasta -r $ref -i $bam_pwd -c $opt_c -l $gene_region -o deep_seq_SNVer.var.flt.vcf\n";
`java -jar /NAS1/software/SNVerPool.jar -i /NAS2/GWAS_bam_file/bam_file_totoal/ -r /NAS1/data/pseudochromosome/maize_pseudo_chr.fasta -r $ref -i $bam_pwd -c $opt_c -l $gene_region -o deep_seq_SNVer.var.flt.vcf`;

sub usage{
    my $die =<<DIE;
    perl *.pl <region> <deep seq line> <reference fasta> <pwd bamfile>
DIE
}
