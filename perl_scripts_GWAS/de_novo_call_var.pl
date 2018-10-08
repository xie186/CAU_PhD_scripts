#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 4;

my ($clus, $prop_cut,$gene, $ref) = @ARGV;
open CLUS,$clus or die "$!";
my $haplo_group = 1;
my %hash_group;
while(<CLUS>){
    chomp;
    my($id1,$id2,$prop,$tot_inbred,$inbred_name)  = split;
    next if $prop < $prop_cut;
    my @inbred_name = split(/-/,$inbred_name);
    push @{$hash_group{$haplo_group}},@inbred_name;
    ++ $haplo_group;
}

my @bam_file;
foreach my $group(keys %hash_group){
     my $assembly_fa = "$gene\_group$group.fa.cap.contigs";
#     `bwa bwasw -H $ref ./tem_fq/$assembly_fa |samtools view -bS - |samtools sort - $gene\_group$group.srt`;
     `/NAS1/software/bowtie2-2.0.0-beta7/bowtie2 $ref ./tem_fq/$assembly_fa -f --rg-id "PL:ILLUMINA" --rg "SM:group$group" |samtools view -bS - |samtools sort - $gene\_group$group.srt`;
     `samtools index $gene\_group$group.srt.bam`;
#     print "bwa bwasw -H $ref ./tem_fq/$assembly_fa |samtools view -bS - |samtools sort - $gene\_group$group.srt\n";
     print "bowtie2 $ref ./tem_fq/$assembly_fa -f --rg-id \"illumima:group$group\" --rg \"illumima:group$group\" |samtools view -bS - |samtools sort - $gene\_group$group.srt \n";
     push @bam_file, "-I $gene\_group$group.srt.bam";
}

#`samtools mpileup -uf $ref @bam_file |/NAS1/software/samtools/bcftools/bcftools view -bvcg - |/NAS1/software/samtools/bcftools/bcftools view - |/NAS1/software/samtools/bcftools/vcfutils.pl varFilter -D100 > $gene.var.flt.vcf`;
`java -Xmx6G -XX:-UseGCOverheadLimit -jar /NAS1/software/GenomeAnalysisTK-1.0.5974/GenomeAnalysisTK.jar -R /NAS1/data/pseudochromosome/maize_pseudo_chr.fasta -T UnifiedGenotyper -glm BOTH  @bam_file -o $gene.var.flt.vcf -A AlleleBalance -stand_call_conf 4.0 -stand_emit_conf 3.0 -mbq 20 -mmq 20`;
print "java -Xmx6G -XX:-UseGCOverheadLimit -jar /NAS1/software/GenomeAnalysisTK-1.0.5974/GenomeAnalysisTK.jar -R /NAS1/data/pseudochromosome/maize_pseudo_chr.fasta -T UnifiedGenotyper @bam_file -o $gene.var.flt.vcf -A AlleleBalance -stand_call_conf 4.0 -stand_emit_conf 3.0 -mbq 20 -mmq 20\n";
sub usage{
    my $die =<<DIE;
    perl *.pl <clus> <prop_cut> <gene> <reference genome>
DIE
}
