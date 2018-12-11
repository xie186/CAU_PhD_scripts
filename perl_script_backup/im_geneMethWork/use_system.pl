#!/usr/bin/perl 

while(<>){
    chomp;
    system qq(grep "$_" ~/mapping_result/Endosperm/share/data/staff/tianf/Maize/100918_FC620J3AAXX_Batch_6/Raw_fq/en1_bwa_m.pileup >$_.en1_bwa_m.pileup);
    system qq(grep "$_" ~/mapping_result/Endosperm/share/data/staff/tianf/Maize/100918_FC620J3AAXX_Batch_6/Raw_fq/en2_bwa_m.pileup >$_.en2_bwa_m.pileup);
    system qq(grep "$_" ../../endosperm_norep_allele_depth10_chi67 >$_.snp);
    system qq(grep "$_" ~/zhaohainan/mapanalyze/intergenic/ZmB73_4a.53_WGS.gff >$_.stru);
}
