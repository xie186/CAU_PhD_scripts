pdf("endo_meth_dis_3gene.pdf");cpg<-read.table("meth_dis_thr_gene_endo_CpG.srt");plot(cpg[cpg[,1]=="transposable_element",][,4],type="l",ylim=c(0,100),col="red");lines(cpg[cpg[,1]=="pseudogene",][,4],type="l",col="ForestGreen");lines(cpg[cpg[,1]=="protein_coding",][,4],type="l",col="blue");abline(v=20.5,lty="dashed");abline(v=120.5,lty="dashed");dev.off()
   
