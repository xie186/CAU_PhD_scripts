
# *stat file transferred form gonlab server: /home/gonglab/zeamxie/gong_lab/wangjingyi/smRNA_ana/bowtie_align_tair10


R --vanilla --slave --input smRNA_cluster_col119_4rep_ssh1_rep1.txt --tot 18083271,13636098 --output smRNA_cluster_col119_4rep_ssh1_rep1.fisherBH < /scratch/conte/x/xie186/gonglab/LiQing/scripts/smRNA_clus_fisher.R
R --vanilla --slave --input smRNA_cluster_col119_4rep_nrpd1_rep1.txt --tot 18083271,14099947 --output smRNA_cluster_col119_4rep_nrpd1_rep1.fisherBH < /scratch/conte/x/xie186/gonglab/LiQing/scripts/smRNA_clus_fisher.R
R --vanilla --slave --input smRNA_cluster_col119_4rep_drm2_rep1.txt --tot 18083271,15618891 --output smRNA_cluster_col119_4rep_drm2_rep1.fisherBH < /scratch/conte/x/xie186/gonglab/LiQing/scripts/smRNA_clus_fisher.R
R --vanilla --slave --input smRNA_cluster_col119_4rep_BN1_39.txt --tot 18083271,15151357 --output smRNA_cluster_col119_4rep_BN1_39.fisherBH < /scratch/conte/x/xie186/gonglab/LiQing/scripts/smRNA_clus_fisher.R
R --vanilla --slave --input smRNA_cluster_col119_4rep_BN1_40.txt --tot 18083271,14344999 --output smRNA_cluster_col119_4rep_BN1_40.fisherBH < /scratch/conte/x/xie186/gonglab/LiQing/scripts/smRNA_clus_fisher.R

#drm2_rep1.stat 15618891
#nrpd1_rep1.stat 14099947
#smRNA_1-20C3_collap.stat 13636098
#BN1_39_clean.stat 15151357
#BN1_40_clean.stat 14344999

#smRNA_cluster_col119_4rep_BN1_39.txt  smRNA_cluster_col119_4rep_drm2_rep1.txt   smRNA_cluster_col119_4rep_ssh1_rep1.txt
#smRNA_cluster_col119_4rep_BN1_40.txt  smRNA_cluster_col119_4rep_nrpd1_rep1.txt


