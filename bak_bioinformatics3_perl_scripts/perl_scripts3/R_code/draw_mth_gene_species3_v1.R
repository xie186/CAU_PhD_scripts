draw_mth_gene_spec3<-function(ara,rice,zm,contxt,bg){
    ara<-read.table(ara)
    rice<-read.table(rice)
    zm<-read.table(zm)
    bg<-read.table(bg)
    
    rang<-range(0,ara[,3],rice[,3],bg[,3])
    plot(ara[,3],type="l",col="red",ylim=rang,ylab="",axes=FALSE,xlab="",main=contxt)
    lines(rice[,3],col="royalblue")
    lines(zm[,3],col="darkgreen")
    abline(v=20.5,lty="dashed",col="grey")
    abline(v=120.5,lty="dashed",col="grey")
    axis(2)
    axis(1,label=FALSE,tick=FALSE) 
    mtext(c("Gene model"),side=1,line=0.5)
    mtext(c("Methylation Level(%)"),side=2,line=2)
    box()
}
