#/home/gonglab/software/bowtie-1.1.1/bowtie --sam -f -v 0 -m 1 ~/data/arabidopsis/TAIR10_chr_all.fasta BN1_40_clean.fa |/home/gonglab/software/samtools-1.2/samtools view -bS - |/home/gonglab/software/samtools-1.2/samtools sort - BN1_40.srt &
#/home/gonglab/software/bowtie-1.1.1/bowtie --sam -f -v 0 -m 1 ~/data/arabidopsis/TAIR10_chr_all.fasta BN1_39_clean.fa |/home/gonglab/software/samtools-1.2/samtools view -bS - |/home/gonglab/software/samtools-1.2/samtools sort - BN1_39.srt &
#/home/gonglab/software/bowtie-1.1.1/bowtie --sam -f -v 0 -m 1 ~/data/arabidopsis/TAIR10_chr_all.fasta BN1_38_clean.fa |/home/gonglab/software/samtools-1.2/samtools view -bS - |/home/gonglab/software/samtools-1.2/samtools sort - BN1_38.srt &
#/home/gonglab/software/bowtie-1.1.1/bowtie --sam -f -v 0 -m 1 ~/data/arabidopsis/TAIR10_chr_all.fasta BN1_37_clean.fa |/home/gonglab/software/samtools-1.2/samtools view -bS - |/home/gonglab/software/samtools-1.2/samtools sort - BN1_37.srt 

 /group/bioinfo/apps/apps/bowtie-1.1.1/bowtie --sam -f -v 0 -m 1 ../../raw_data/reference/ara/TAIR10_chr_all.fasta smRNA_ssh1_rep1_collap.fa |/group/bioinfo/apps/apps/samtools-1.2/bin/samtools view -bS - |/group/bioinfo/apps/apps/samtools-1.2/bin/samtools sort - smRNA_ssh1_rep1.srt

#BN1_37_clean.fa  BN1_38_clean.fa  BN1_39_clean.fa  BN1_40_clean.fa
