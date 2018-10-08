#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 3;
my ($region, $deep_seq, $ref) = @ARGV;
open DEEP,$deep_seq or die "$!";
my %hash_inbred;
while(<DEEP>){
    chomp;
    next if /##/;
    my ($cau_acc,$inbred) = split;
    $hash_inbred{$cau_acc} = $inbred;
}
open REG,$region or die "$!";
while(<REG>){
    chomp;
    my ($chr,$stt,$end,$gene) = split;
       ($stt,$end) = ($stt - 2000,$end + 2000);
    my $gene_pos = "chr$chr:$stt-$end";
    my @bam_file;
    foreach my $cau_acc(keys %hash_inbred){
#        my $assembly_fa = "$gene\_$cau_acc.fa.final_scaffold.fa.final.scaffolds.fasta";
        my $assembly_fa = "$gene\_$cau_acc.fa.cap.contigs";
#        `bwa bwasw -H $ref ./tem_fq/$assembly_fa |samtools view -bS - |samtools sort - $gene\_$cau_acc.srt`;
#        print "bwa bwasw -H $ref ./tem_fq/$assembly_fa |samtools view -bS - |samtools sort - $gene\_$cau_acc.srt\n";
#        `/NAS1/software/bowtie2-2.0.0-beta7/bowtie2 $ref ./tem_fq/$assembly_fa -f --rg-id "PL:ILLUMINA" --rg "SM:$cau_acc" |samtools view -bS - |samtools sort - $gene\_$cau_acc.srt`;
#        `samtools index $gene\_$cau_acc.srt.bam`;
        push @bam_file, "-I $gene\_$cau_acc.srt.bam";
    }
#    `samtools merge -r $gene.merge.bam @bam_file`;
#    `samtools mpileup -uf $ref @bam_file |/NAS1/software/samtools/bcftools/bcftools view -bvcg - |/NAS1/software/samtools/bcftools/bcftools view - |/NAS1/software/samtools/bcftools/vcfutils.pl varFilter -D100 > $gene.var.flt.vcf`; 
    `java -Xmx6G -XX:-UseGCOverheadLimit -jar /NAS1/software/GenomeAnalysisTK-1.0.5974/GenomeAnalysisTK.jar -R /NAS1/data/pseudochromosome/maize_pseudo_chr.fasta -T UnifiedGenotyper -glm BOTH  @bam_file -o $gene.var.flt.vcf -A AlleleBalance -stand_call_conf 4.0 -stand_emit_conf 3.0 -mbq 20 -mmq 20`;
    print "java -Xmx6G -XX:-UseGCOverheadLimit -jar /NAS1/software/GenomeAnalysisTK-1.0.5974/GenomeAnalysisTK.jar -R /NAS1/data/pseudochromosome/maize_pseudo_chr.fasta -T UnifiedGenotyper @bam_file -o $gene.var.flt.vcf -A AlleleBalance -stand_call_conf 4.0 -stand_emit_conf 3.0 -mbq 20 -mmq 20\n"; 
}

sub usage{
    my $die =<<DIE;
    perl *.pl <region> <deep seq line> <reference fasta>
DIE
}
