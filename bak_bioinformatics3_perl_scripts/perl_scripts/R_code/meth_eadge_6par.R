meth_eadge_firexon<-function(cpg,CG,chg,CHG,chh,CHH){

    #exp 
    cpg<-read.table(cpg)
    chg<-read.table(chg)
    chh<-read.table(chh)
    #no exp
    CG<-read.table(CG)
    CHG<-read.table(CHG)
    CHH<-read.table(CHH)
    par(mfrow=c(3,2))
    #exp CpG
    
    plot(cpg[1:201,3],type="l",ylim=c(min(cpg[,3],CG[,3]),max(cpg[,3],CG[,3])),xlim=c(0,450),col="red",xlab="CpG",ylab="Methylation Level")
    abline(v=101,lty="dashed")
    lines(212:412,cpg[202:402,3],col="red")
    abline(v=313,lty="dashed")
    #no exp CpG
    plot(CG[1:201,3],type="l",ylim=c(min(cpg[,3],CG[,3]),max(cpg[,3],CG[,3])),xlim=c(0,450),col="red",xlab="CpG",ylab="Methylation Level")
    abline(v=101,lty="dashed")
    lines(212:412,CG[202:402,3],col="red")
    abline(v=313,lty="dashed")

    plot(chg[1:201,3],type="l",ylim=c(min(chg[,3],CHG[,3]),max(chg[,3],CHG[,3])),xlim=c(0,450),col="RoyalBlue",xlab="CHG",ylab="Methylation Level")
    abline(v=101,lty="dashed")
    lines(212:412,chg[202:402,3],col="RoyalBlue")
    abline(v=313,lty="dashed")
    #no exp CpG
    plot(CHG[1:201,3],type="l",ylim=c(min(chg[,3],CHG[,3]),max(chg[,3],CHG[,3])),xlim=c(0,450),col="RoyalBlue",xlab="CHG",ylab="Methylation Level")
    abline(v=101,lty="dashed")
    lines(212:412,CHG[202:402,3],col="RoyalBlue")
    abline(v=313,lty="dashed")

    plot(chh[1:201,3],type="l",ylim=c(min(chh[,3],CHH[,3]),max(chh[,3],CHH[,3])),xlim=c(0,450),col="PaleGreen4",xlab="CHH",ylab="Methylation Level")
     abline(v=101,lty="dashed")
     lines(212:412,chh[202:402,3],col="PaleGreen4")
     abline(v=313,lty="dashed")
     #no exp CpG
    plot(CHH[1:201,3],type="l",ylim=c(min(chh[,3],CHH[,3]),max(chh[,3],CHH[,3])),xlim=c(0,450),col="PaleGreen4",xlab="CHH",ylab="Methylation Level")
    abline(v=101,lty="dashed")
    lines(212:412,CHH[202:402,3],col="PaleGreen4")
    abline(v=313,lty="dashed")

}
