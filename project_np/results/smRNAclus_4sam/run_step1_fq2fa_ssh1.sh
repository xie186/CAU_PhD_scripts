../../softwares/fastx_toolkit-0.0.13.2/bin/fastx_clipper -v -a TGGAATTCTCGGGTGCCAAGG -Q 33 -i ../../raw_data/SRR788209.fastq -o smRNA_ssh1_rep1_trim.fq

perl ../../scripts/smRNA_fq2fa4cluster.pl smRNA_ssh1_rep1_trim.fq smRNA_ssh1_rep1_collap.fa > smRNA_1-20C3_collap.stat

