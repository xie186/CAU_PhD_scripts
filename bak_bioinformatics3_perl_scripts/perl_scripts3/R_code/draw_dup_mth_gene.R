draw_mth_gene<-function(mth_ge,contxt){
    
    cc<-read.table(mth_ge)
    sub1<-cc[cc[,1]==1,]
    sub2<-cc[cc[,1]==2,]
    rang<-range(0,sub1[,4],sub2[,4])
    plot(sub1[,4],type="l",col="red",axes=FALSE,ylab="",xlab="",ylim=rang,main=contxt)
    lines(sub2[,4],col="royalblue")
    abline(v=20,lty="dashed",col="grey")
    abline(v=120,lty="dashed",col="grey")
    axis(1,labels=FALSE,tick=FALSE)
    mtext(c("Gene Body"),side=1,line=0.5)
    mtext(c("Methylation Level(%)"),side=2,line=2)
    axis(2)
    box()
} 
