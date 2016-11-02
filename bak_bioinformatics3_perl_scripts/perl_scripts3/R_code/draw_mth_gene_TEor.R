draw_mth_gene<-function(mth_te,mth_nt,contxt){
    
    cc<-read.table(mth_te)
    dd<-read.table(mth_nt)
    rang<-range(0,cc[,3],dd[,3])
    plot(cc[,3],type="l",col="red",axes=FALSE,ylab="",xlab="",ylim=rang,main=contxt)
    lines(dd[,3],col="royalblue")
    abline(v=20,lty="dashed",col="grey")
    abline(v=120,lty="dashed",col="grey")
    axis(1,labels=FALSE,tick=FALSE)
    mtext(c("Gene Body"),side=1,line=0.5)
    mtext(c("Methylation Level(%)"),side=2,line=2)
    axis(2)
    box()

} 
