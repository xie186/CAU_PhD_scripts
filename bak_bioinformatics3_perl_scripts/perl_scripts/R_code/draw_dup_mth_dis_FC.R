draw_dup_mth_dis_FC<-function(CG,contxt){
    cg<-read.table(CG)     
    rang<-range(0,cg[,4])

    plot(cg[cg[,1]=="paired1_rpkm_big",][,4],type="l",col="red",ylim=rang,ylab="",main=contxt,axes=FALSE,xlab="")
    lines(cg[cg[,1]=="paired2_rpkm_small",][,4],col="blue")
    abline(v=20.5,lty="dashed",col="grey")
    abline(v=120.5,lty="dashed",col="grey")

    axis(2)
    axis(1,label=FALSE,tick=FALSE)
    mtext(c("Gene"),side=1,line=0.5)
    mtext(c("Methylation Level (%)"),side=2,line=2)
    box();
}
