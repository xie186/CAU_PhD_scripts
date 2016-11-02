DEG_mth_dis_3tis<-function(cont,mth_contxt,OUT){

    cc<-read.table(cont)
    pdf(OUT)
    maxi<-max(cc[,3],cc[,4],cc[,5])
    plot(cc[,3],type="l",col="red",ylim=c(0,maxi),xlab=mth_contxt,ylab="Methylation percentage")
    lines(cc[,4],col="blue")
    lines(cc[,5],col="DarkGreen")
    

    abline(v=20.5,lty="dashed",col="grey")
    abline(v=120.5,lty="dashed",col="grey")
    dev.off()
}

