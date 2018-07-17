bamToBed -i BN1_37.srt.bam |intersectBed -a ~/data/arabidopsis/TAIR10_chr_all.win200bp.txt -b - -wa -wb  > tair10_win200bp_intersect_BN1_37.txt 
bamToBed -i BN1_39.srt.bam |intersectBed -a ~/data/arabidopsis/TAIR10_chr_all.win200bp.txt -b - -wa -wb  > tair10_win200bp_intersect_BN1_39.txt 
bamToBed -i BN1_38.srt.bam |intersectBed -a ~/data/arabidopsis/TAIR10_chr_all.win200bp.txt -b - -wa -wb  > tair10_win200bp_intersect_BN1_38.txt 
bamToBed -i BN1_40.srt.bam |intersectBed -a ~/data/arabidopsis/TAIR10_chr_all.win200bp.txt -b - -wa -wb  > tair10_win200bp_intersect_BN1_40.txt 

bamToBed -i smRNA_ssh1_rep1.srt.bam |intersectBed -a TAIR10_chr_all.win200bp.txt -b - -wa -wb  > tair10_win200bp_intersect_ssh1_rep1.txt


