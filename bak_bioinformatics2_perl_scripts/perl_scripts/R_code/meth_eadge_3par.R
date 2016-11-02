meth_eadge_3par<-function(cpg,chg,chh){
#    pdf(OUT,width=6,height=8)
    #exp 
    cpg<-read.table(cpg)
    chg<-read.table(chg)
    chh<-read.table(chh)
    par(mfrow=c(3,1))
    
    plot(lowess(cpg[1:201,3],f=0.05),type="l",xlim=c(0,450),col="red",xlab="CpG",ylab="Methylation Level")
    abline(v=101,lty="dashed")
    lines(212:412, lowess(cpg[202:402,3], f=0.05),col="red")
    abline(v=313,lty="dashed")

    plot(chg[1:201,3],type="l",xlim=c(0,450),col="RoyalBlue",xlab="CHG",ylab="Methylation Level")
    abline(v=101,lty="dashed")
    lines(212:412,chg[202:402,3],col="RoyalBlue")
    abline(v=313,lty="dashed")

    plot(chh[1:201,3],type="l",xlim=c(0,450),col="PaleGreen4",xlab="CHH",ylab="Methylation Level")
     abline(v=101,lty="dashed")
     lines(212:412,chh[202:402,3],col="PaleGreen4")
     abline(v=313,lty="dashed")

#    dev.off()
}
