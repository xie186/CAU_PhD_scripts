meth_distr_expor_3par<-function(cpg_exp,cpg_noexp,chg_exp,chg_noexp,chh_exp,chh_noexp,pdf){
    cg<-read.table(cpg_exp)
    CG<-read.table(cpg_noexp)
    
    chg<-read.table(chg_exp)
    CHG<-read.table(chg_noexp)
   
    chh<-read.table(chh_exp)
    CHH<-read.table(chh_noexp)

    pdf(pdf,width=6,height=8)  
 
    par(mfrow=c(3,1))
    plot(cg[,3],col="red",ylim=c(0,max(cg[,3],CG[,3])),type="l",xlab="CpG",ylab="Methylation level(%)")
    lines(CG[,3],col="DarkBlue")
    abline(v=20.5,lty="dashed",col="grey")
    abline(v=120.5,lty="dashed",col="grey")
    
    plot(chg[,3],col="red",ylim=c(0,max(chg[,3],CHG[,3])),type="l",xlab="CHG",ylab="Methylation level(%)")
    lines(CHG[,3],col="DarkBlue")
    abline(v=20.5,lty="dashed",col="grey")
    abline(v=120.5,lty="dashed",col="grey")

    plot(chh[,3],col="red",ylim=c(0,max(chh[,3],CHH[,3])),type="l",xlab="CHH",ylab="Methylation level(%)")
    lines(CHH[,3],col="DarkBlue")
    abline(v=20.5,lty="dashed",col="grey")
    abline(v=120.5,lty="dashed",col="grey")

    dev.off()
}
