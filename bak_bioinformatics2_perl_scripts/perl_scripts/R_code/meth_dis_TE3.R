meth_dis_TE3<-function(cpg,chg,chh,OUT){
    pdf(OUT)
    cpg<-read.table(cpg)
    chg<-read.table(chg)
    chh<-read.table(chh)
    par(mfrow=c(3,1))

 #   plot(cpg[,3],type="l",ylim=c(min(cpg[,3]),max(cpg[,3])),col="red")
     plot(cpg[,3],type="l",ylim=c(0,max(cpg[,3])),col="red")
    abline(v=20.5,lty="dashed")
    abline(v=120.5,lty="dashed")

    plot(chg[,3],type="l",ylim=c(0,max(chg[,3])),col="RoyalBlue")
    abline(v=20.5,lty="dashed")
    abline(v=120.5,lty="dashed")
    
    plot(chh[,3],type="l",ylim=c(0,max(chh[,3])),col="PaleGreen4")
    abline(v=20.5,lty="dashed")
    abline(v=120.5,lty="dashed")
    dev.off()
}
