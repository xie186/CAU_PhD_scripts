draw_mth_high_low_exp_exp<-function(cpg_low,cpg_nonexp_low,cpg_hi,cpg_nonexp_hi,chg_low,chg_nonexp_low,chg_hi,chg_nonexp_hi,chh_low,chh_nonexp_low,chh_hi,chh_nonexp_hi){
    cpg_l<-read.table(cpg_low)
    chg_l<-read.table(chg_low)
    chh_l<-read.table(chh_low)    
   
    cpg_h<-read.table(cpg_hi)
    chg_h<-read.table(chg_hi)
    chh_h<-read.table(chh_hi)
   
    cpg_nonexp_l<-read.table(cpg_nonexp_low)
    chg_nonexp_l<-read.table(chg_nonexp_low)
    chh_nonexp_l<-read.table(chh_nonexp_low)

    cpg_nonexp_h<-read.table(cpg_nonexp_hi)
    chg_nonexp_h<-read.table(chg_nonexp_hi)
    chh_nonexp_h<-read.table(chh_nonexp_hi)
    
    par(mfrow=c(3,2))    
 
    maxi<-max(cpg_l[,3],cpg_nonexp_l[,3],cpg_h[,3],cpg_nonexp_h[,3])
    plot(cpg_l[,3],type="l",col="red",ylim=c(0,maxi),xlab="CpG",ylab="Methylation level")
    lines(cpg_nonexp_l[,3],col="blue")
  
    plot(cpg_h[,3],type="l",col="red",ylim=c(0,maxi),xlab="CpG",ylab="Methylation level")
    lines(cpg_nonexp_h[,3],col="blue")
  
     ##CHG
     maxi<-max(chg_l[,3],chg_nonexp_l[,3],chg_h[,3],chg_nonexp_h[,3])
     plot(chg_l[,3],type="l",col="red",ylim=c(0,maxi),xlab="CHG",ylab="Methylation level")
     lines(chg_nonexp_l[,3],col="blue")

     plot(chg_h[,3],type="l",col="red",ylim=c(0,maxi),xlab="CHG",ylab="Methylation level")
     lines(chg_nonexp_h[,3],col="blue")
  
     ##CHH
     maxi<-max(chh_l[,3],chh_nonexp_l[,3],chh_h[,3],chh_nonexp_h[,3])
     plot(chh_l[,3],type="l",col="red",ylim=c(0,maxi),xlab="CHH",ylab="Methylation level")
     lines(chh_nonexp_l[,3],col="blue")

     plot(chh_h[,3],type="l",col="red",ylim=c(0,maxi),xlab="CHH",ylab="Methylation level")
     lines(chh_nonexp_h[,3],col="blue") 
}
