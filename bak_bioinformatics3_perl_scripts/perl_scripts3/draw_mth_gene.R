draw_mth_gene<-function(mth_lc,mth_hc,contxt){
    lc<-read.table(mth_lc)
    hc<-read.table(mth_hc)
    rang<-range(0,lc[,3],hc[,3])
    plot(lc[,3],type="l",col="red",axes=FALSE,ylab="",xlab="",ylim=rang,main=contxt)
    lines(hc[,3],col="royalblue")
    abline(v=20.5,lty="dashed")
    abline(v=120.5,lty="dashed")
    axis(1,labels=FALSE,tick=FALSE)
    mtext(c("Gene"),side=1,line=0.5)
    mtext(c("Methylation Level(%)"),side=2,line=2)
    axis(2)
    box()
} 
