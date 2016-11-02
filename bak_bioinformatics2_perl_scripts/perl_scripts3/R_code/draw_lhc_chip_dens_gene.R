draw_lhc_chip_dens_gene<-function(chip_dens,contxt){
    chip<-read.table(chip_dens)
    plot(chip[chip[,3]=="TE",][,4],type="l",ylim=range(chip[,4]),col="red",axes=FALSE,xlab="",ylab="",main=contxt)
    lines(chip[chip[,3]=="NT",][,4],col="royalblue")
    abline(v=10,lty="dashed",col="grey")
    abline(v=30,lty="dashed",col="grey")
    axis(1,labels=FALSE,tick=FALSE)
    mtext(c("Gene Body"),side=1,line=0.5)
    mtext(c("Average Depth(bp)"),side=2,line=2)
    axis(2)
    box()
}
