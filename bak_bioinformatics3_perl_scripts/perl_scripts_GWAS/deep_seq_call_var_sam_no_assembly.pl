#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 4;
my ($region, $deep_seq, $ref, $bam_pwd) = @ARGV;
open DEEP,$deep_seq or die "$!";
my %hash_inbred;
while(<DEEP>){
    chomp;
    next if /##/;
    my ($cau_acc,$inbred) = split;
    $hash_inbred{$cau_acc} = $inbred;
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

my @bam_file;
foreach my $cau_acc(keys %hash_inbred){
     push @bam_file, "$bam_pwd/$cau_acc.sorted.picard.bam";
}

print "samtools mpileup -q 20 -Q 13 -uf $ref @bam_file -l $gene_region |/NAS1/software/samtools/bcftools/bcftools view -bvcg - |/NAS1/software/samtools/bcftools/bcftools view - |/NAS1/software/samtools/bcftools/vcfutils.pl varFilter -D100 > deep_seq.var.flt.vcf\n";
`samtools mpileup -q 20 -Q 13 -uf $ref @bam_file -l $gene_region |/NAS1/software/samtools/bcftools/bcftools view -bvcg - |/NAS1/software/samtools/bcftools/bcftools view - |/NAS1/software/samtools/bcftools/vcfutils.pl varFilter -D100 > deep_seq.var.flt.vcf`;

sub usage{
    my $die =<<DIE;
    perl *.pl <region> <deep seq line> <reference fasta> <pwd bamfile>
DIE
}
