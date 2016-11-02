draw_te_dis_gene<-function(dis){
    cc<-read.table(dis)
    plot(lowess(cc[,2], f = 0.03),axes=FALSE,xlab="",ylab="",type="l")
    axis(2)
    axis(1,label=FALSE,tick=FALSE)
    mtext(c("TE"),side=1,line=0.5)
    mtext(c("Average numbers per 1M"),side=2,line=2)
    abline(v = 20.5,lty = "dashed")
    abline(v = 120.5,lty = "dashed")
    box()
}
