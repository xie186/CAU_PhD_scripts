dup_mth_dis_gene_3context<-function(CG,CHG,CHH){
    cg<-read.table(CG)
    chg<-read.table(CHG)
    chh<-read.table(CHH)
#    pdf(pdf,width=7,height=10);
     
    par(mfrow=c(3,1),mar=c(3.5,4,1,0));
    maxi<-max(cg[cg[,1]=="paired1_rpkm_big",][,4],cg[cg[,1]=="paired2_rpkm_small",][,4]);
    plot(cg[cg[,1]=="paired1_rpkm_big",][,4],type="l",col="red",ylim=c(0,maxi),ylab="Methylation Level(%)",xlab="CpG");
    lines(cg[cg[,1]=="paired2_rpkm_small",][,4],col="blue");
    abline(v=20.5,lty="dashed",col="grey")
    abline(v=120.5,lty="dashed",col="grey")
   
    maxi<-max(chg[chg[,1]=="paired1_rpkm_big",][,4],chg[chg[,1]=="paired2_rpkm_small",][,4]);
    plot(chg[chg[,1]=="paired1_rpkm_big",][,4],type="l",col="red",ylim=c(0,maxi),ylab="Methylation Level(%)",xlab="CHG");
    lines(chg[chg[,1]=="paired2_rpkm_small",][,4],col="blue");
    abline(v=20.5,lty="dashed",col="grey")
    abline(v=120.5,lty="dashed",col="grey") 

    maxi<-max(chh[chh[,1]=="paired1_rpkm_big",][,4],chh[chh[,1]=="paired2_rpkm_small",][,4])
    plot(chh[chh[,1]=="paired1_rpkm_big",][,4],type="l",col="red",ylim=c(0,maxi),ylab="Methylation Level(%)",xlab="CHH");
    lines(chh[chh[,1]=="paired2_rpkm_small",][,4],col="blue");
    abline(v=20.5,lty="dashed",col="grey")
    abline(v=120.5,lty="dashed",col="grey")
    
    dev.off();
}
