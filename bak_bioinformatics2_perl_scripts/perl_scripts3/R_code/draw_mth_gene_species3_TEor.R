draw_mth_gene_spec3_TEor<-function(ara,ara_nt,rice,rice_nt,zm,zm_nt,contxt){
    ara<-read.table(ara)
    rice<-read.table(rice)
    zm<-read.table(zm)
    ara_nt<-read.table(ara_nt)
    rice_nt<-read.table(rice_nt)
    zm_nt<-read.table(zm_nt)
    
    rang<-range(0,ara[,3],rice[,3],zm[,3])
    plot(ara[,3],type="l",col="red",ylim=rang,ylab="",axes=FALSE,xlab="",main=contxt)
    lines(rice[,3],col="royalblue")
    lines(zm[,3],col="darkgreen")
   
    lines(ara_nt[,3],col="red",lty="dashed")
    lines(rice_nt[,3],col="royalblue",lty="dashed")
    lines(zm_nt[,3],col="darkgreen",lty="dashed")

    abline(v=20.5,lty="dashed",col="grey")
    abline(v=120.5,lty="dashed",col="grey")
    axis(2)
    axis(1,label=FALSE,tick=FALSE) 
    mtext(c("Gene model"),side=1,line=0.5)
    mtext(c("Methylation Level(%)"),side=2,line=2)
    box()
}
