meth_eadge_3par<-function(cpg,chg,chh,endo_cpg,endo_chg,endo_chh,OUT){
    pdf(OUT,width=6,height=8)
    #exp 
    cpg<-read.table(cpg)
    chg<-read.table(chg)
    chh<-read.table(chh)
   
    endo_cpg<-read.table(endo_cpg)
    endo_chg<-read.table(endo_chg)
    endo_chh<-read.table(endo_chh)
    par(mfrow=c(3,1))
    
#    red:seedlings PaleGreen4:endosperm
       
 
    plot(cpg[1:201,3],type="l",xlim=c(0,450),ylim=c(0,max(cpg[,3],endo_cpg[,3])),col="red",xlab="CpG",ylab="Methylation Level")
    abline(v=101,lty="dashed")
    lines(212:412,cpg[202:402,3],col="red")
    abline(v=313,lty="dashed")
    lines(1:201,endo_cpg[1:201,3],col="PaleGreen4")
    lines(212:412,endo_cpg[202:402,3],col="PaleGreen4")


    plot(chg[1:201,3],type="l",xlim=c(0,450),col="red",xlab="CHG",ylab="Methylation Level")
    abline(v=101,lty="dashed")
    lines(212:412,chg[202:402,3],col="red")
    abline(v=313,lty="dashed")
     lines(1:201,endo_chg[1:201,3],col="PaleGreen4")
    lines(212:412,endo_chg[202:402,3],col="PaleGreen4")

    plot(chh[1:201,3],type="l",xlim=c(0,450),col="red",xlab="CHH",ylab="Methylation Level")
     abline(v=101,lty="dashed")
     lines(212:412,chh[202:402,3],col="red")
     abline(v=313,lty="dashed")
     lines(1:201,endo_chh[1:201,3],col="PaleGreen4")
    lines(212:412,endo_chh[202:402,3],col="PaleGreen4")
     

    dev.off()
}
