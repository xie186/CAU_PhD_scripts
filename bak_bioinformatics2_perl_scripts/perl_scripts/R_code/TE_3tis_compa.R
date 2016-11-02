TE_3tis_compa<-function(CG,CHG,CHH){

    cg<-read.table(CG,sep="\t")
    chg<-read.table(CHG,sep="\t")
    chh<-read.table(CHH,sep="\t")
#    pdf(fig,width=7,height=9)
#    par(mfrow=c(3,1)) 
    yax<-max(cg[,7]-cg[,9],cg[,7]-cg[,11],cg[,9]-cg[,11])
    plot(density(cg[,7]-cg[,9]),xlim=c(-yax,yax),col="red",main="CpG")
    lines(density(cg[,7]-cg[,11]),col="blue")
    lines(density(cg[,9]-cg[,11]),col="DarkGreen");
    abline(v=0,lty="dashed")
       
    yax<-max(chg[,7]-chg[,9],chg[,7]-chg[,11],chg[,9]-chg[,11])
    plot(density(chg[,7]-chg[,9]),xlim=c(-yax,yax),col="red",main="CHG")
    lines(density(chg[,7]-chg[,11]),col="blue")
    lines(density(chg[,9]-chg[,11]),col="DarkGreen");
    abline(v=0,lty="dashed")
  
    yax<-max(chh[,7]-chh[,9],chh[,7]-chh[,11],chh[,9]-chh[,11])
    plot(density(chh[,7]-chh[,9]),xlim=c(-yax,yax),col="red","CHH")
    lines(density(chh[,7]-chh[,11]),col="blue")
    lines(density(chh[,9]-chh[,11]),col="DarkGreen")
    abline(v=0,lty="dashed")
 
}

