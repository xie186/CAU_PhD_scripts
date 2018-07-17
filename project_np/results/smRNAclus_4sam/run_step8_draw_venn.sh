R --vanilla --slave --input smRNA_cluster_col119_4rep_BN1_39.fisherBH,smRNA_cluster_col119_4rep_BN1_40.fisherBH,smRNA_cluster_col119_4rep_drm2_rep1.fisherBH,smRNA_cluster_col119_4rep_nrpd1_rep1.fisherBH,smRNA_cluster_col119_4rep_ssh1_rep1.fisherBH --sam BN1_39,BN1_40,drm2_rep1,nrpd1_rep1,ssh1_rep1 --output smRNA_clus_mut_depend_venn.pdf <  run_step8_draw_venn.R

R --vanilla --slave --input smRNA_cluster_col119_4rep_BN1_39.fisherBH,smRNA_cluster_col119_4rep_drm2_rep1.fisherBH,smRNA_cluster_col119_4rep_nrpd1_rep1.fisherBH --sam BN1_39,drm2_rep1,nrpd1_rep1 --output smRNA_clus_mut_depend_venn_BN1_39_drm2_nrpd1.pdf <  run_step8_draw_venn.R

R --vanilla --slave --input smRNA_cluster_col119_4rep_BN1_39.fisherBH,smRNA_cluster_col119_4rep_BN1_40.fisherBH,smRNA_cluster_col119_4rep_drm2_rep1.fisherBH,smRNA_cluster_col119_4rep_nrpd1_rep1.fisherBH --sam BN1_39,BN1_40,drm2_rep1,nrpd1_rep1 --output smRNA_clus_mut_depend_BN1_39_40_drm2_nrpd1_venn.pdf <  run_step8_draw_venn.R
