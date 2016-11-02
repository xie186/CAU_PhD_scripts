splice_meth_eadge_3par<-function(cpg,chg,chh,OUT){
    pdf(OUT,width=6,height=8)
    #exp 
    cpg<-read.table(cpg)
    chg<-read.table(chg)
    chh<-read.table(chh)
   
    par(mfrow=c(3,1))
    
#    red:seedlings PaleGreen4:endosperm
       
 
    plot(cpg[1:201,3],type="l",xlim=c(0,450),ylim=c(0,max(cpg[,3],cpg[,4])),col="red",xlab="CpG",ylab="Methylation Level")
    abline(v=101,lty="dashed")
    lines(212:412,cpg[202:402,3],col="red")
    abline(v=313,lty="dashed")
    lines(1:201,cpg[1:201,4],col="PaleGreen4")
    lines(212:412,cpg[202:402,4],col="PaleGreen4")


    plot(chg[1:201,3],type="l",xlim=c(0,450),col="red",xlab="CHG",ylab="Methylation Level",ylim=c(0,max(chg[,3],chg[,4])))
    abline(v=101,lty="dashed")
    lines(212:412,chg[202:402,3],col="red")
    abline(v=313,lty="dashed")
     lines(1:201,chg[1:201,4],col="PaleGreen4")
    lines(212:412,chg[202:402,4],col="PaleGreen4")

    plot(chh[1:201,3],type="l",xlim=c(0,450),col="red",xlab="CHH",ylab="Methylation Level",ylim=c(0,max(chh[,3],chh[,4])))
     abline(v=101,lty="dashed")
     lines(212:412,chh[202:402,3],col="red")
     abline(v=313,lty="dashed")
     lines(1:201,chh[1:201,4],col="PaleGreen4")
    lines(212:412,chh[202:402,4],col="PaleGreen4")
     

    dev.off()
}
