draw_meth_eadge<-function(cpg,chg,chh,OUT){
    pdf(OUT)
    cpg<-read.table(cpg)
    chg<-read.table(chg)
    chh<-read.table(chh)
    par(mfrow=c(3,1))

    plot(cpg[1:201,3],type="l",ylim=c(min(cpg[,3]),max(cpg[,3])),xlim=c(0,450))
    abline(v=101,lty="dashed")
    lines(202:402,cpg[202:402,3])
    abline(v=303,lty="dashed")

    plot(chg[1:201,3],type="l",ylim=c(min(chg[,3]),max(chg[,3])),xlim=c(0,450))
    abline(v=101,lty="dashed")
    lines(202:402,chg[202:402,3])
    abline(v=303,lty="dashed")
    
    plot(chh[1:201,3],type="l",ylim=c(min(chh[,3]),max(chh[,3])),xlim=c(0,450))
    abline(v=101,lty="dashed")
    lines(202:402,chh[202:402,3]);abline(v=303,lty="dashed")
    dev.off()
}
