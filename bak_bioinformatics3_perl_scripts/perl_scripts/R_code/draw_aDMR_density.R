pdf("aDMR_region_mth_den.pdf");cc<-read.table("QDMR_CpG_DMRTable.mer.remth_wthB73_sd_endo_fil30");plot(density(cc[,13]),col="Brown",xlim=c(0,100),ylim=c(0,0.035));lines(density(cc[,5]),col="DarkGreen");lines(density(cc[,7]),col="red");lines(density(cc[,9]),col="blue");lines(density(cc[,11]),col="purple");legend(1,0.035,c("B73 allele","Mo17 allele","B73 inbred","Seedlings","BXM endosperm"),cex=0.8,col=c("DarkGreen","red","blue","purple","brown"),pch=".",lty=1:2);dev.off()



#cc<-read.table("QDMR_CpG_DMRTable.mer.remth_wthB73_sd_endo_fil30");plot(density(cc[,11]),col="Brown",xlim=c(0,100));lines(density(cc[,5]),col="DarkGreen");lines(density(cc[,7]),col="red");lines(density(cc[,9]),col="blue");lines(density(cc[,11]),col="purple")
