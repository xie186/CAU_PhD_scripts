draw_mth_exon_spec3<-function(ara,rice,zm,contxt){
    ara<-read.table(ara)
    rice<-read.table(rice)
    zm<-read.table(zm)
    ara<-ara[order(ara[,2]),]
    rice<-rice[order(rice[,2]),]
    zm<-zm[order(zm[,2]),]
    len <-length(ara[,1])
    cat(len,len/3,len*2/3,"\n")
#    rang<-range(0,ara[,3],rice[,3],zm[,3])
    rang<-range(0,zm[,3],rice[,3],ara[,3])
    plot(ara[,2],ara[,3],type="l",col="red",ylim=rang,ylab="",axes=FALSE,xlab="",main=contxt)
    lines(rice[,2],rice[,3],col="royalblue")
    lines(zm[,2],zm[,3],col="darkgreen")
    abline(v = 0.5,lty="dashed",col="grey")
    abline(v =len/3 + 0.5,lty="dashed",col="grey")
    axis(2)
    axis(1,label=FALSE,tick=FALSE) 
    mtext(c("Gene"),side=1,line=0.5)
    mtext(c("Methylation level(%)"),side=2,line=2)
    box()
}
