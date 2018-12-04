#!/usr/bin/perl -w
use strict;
use Cwd;
my $work_dir = getcwd;

die usage() unless @ARGV == 2;
my ($file, $queue) = @ARGV;

# project dir
my ($project_dir) = split(/\/results/, $work_dir);

open FILE, $file or die "$!";
my $header = <FILE>;
chomp $header;
my @header=split(/\t/, $header);
my @out_dir;
my @sample;
while(<FILE>){
    next if /^#/;
    #Accession      Date    SeqType Backgroud       Genotype        Tissue  Alias   SampleType      Multiplexing    Dir
    my %tem_infor = &extract_infor($_);
    my ($acc, $date, $sample_name, $dir, $samType) = ($tem_infor{"#Accession"}, $tem_infor{"Date"}, $tem_infor{"Alias"}, $tem_infor{"Dir"}, $tem_infor{SampleType});
    my @read1 = <$dir/*R1*gz>;
    my @read2 = <$dir/*R2*gz>;
    my $num = @read1;
    open TEM, "+>$acc\_$sample_name\_$date.qsub" or die "$!";
    my $read1 = join(",", @read1);
    my $read2 = join(",", @read2);
    print TEM <<OUT;
#!/bin/sh -l
#PBS -q $queue
#PBS -l nodes=1:ppn=1
#PBS -l naccesspolicy=shared
#PBS -l walltime=04:00:00
#PBS -N tophat_$sample_name
##PBS -d $work_dir
#PBS -o $acc\_$sample_name\_$date.out
#PBS -e $acc\_$sample_name\_$date.err
cd \$PBS_O_WORKDIR
module load bioinfo samtools/0.1.18
module load python
samtools view -h ../tophat_$acc\_$sample_name\_$date/accepted_hits.bam "chr5:18790736-18796546" |samtools view -bS - > fls2_$acc\_$samType.bam
module load bioinfo
module load picard-tools
PicardCommandLine AddOrReplaceReadGroups I=fls2_$acc\_$samType.bam O=fls2_$acc\_$samType.rg.bam RGID=$acc\_$samType RGLB=$samType RGPL=illumina RGPU=unit1 RGSM=$acc\_$samType 
samtools index fls2_$acc\_$samType.rg.bam
OUT
    push @out_dir, "-I fls2_$acc\_$samType.rg.bam ";
    print "qsub $acc\_$sample_name\_$date.qsub\n";
    close TEM;
}
close FILE;

my $out_dir = join(",", @out_dir);
my $sample = join(",", @sample);
#print "samtools mpileup -uf ../../../raw_data/references/ara/TAIR10_chr_all.fasta @out_dir | bcftools view -bvcg - > var.raw.bcf \n bcftools view var.raw.bcf | vcfutils.pl varFilter -D100 > var.flt.vcf\n";

print <<OUT;
module load bioinfo GATK
GenomeAnalysisTK -T HaplotypeCaller -R TAIR10_chr_all_reorder.fasta @out_dir -o output.raw.snps.indels.vcf  
OUT
sub extract_infor{
    my ($line) = @_;
    my @line = split(/\t/, $line);
    my %tem_hash;
    for(my $i=0; $i < @line; ++$i){
        $line[$i] =~ s/\s+/-/g;
        $line[$i] =~ s/-$//g;
        $tem_hash{$header[$i]} = $line[$i];
    }
    return %tem_hash;
}


sub usage{
my $die =<<DIE;
perl *.pl <File List> <queues> 
DIE
}

