draw_mth_TE_diff_type<-function(mth,TE_type,class,contxt){
    cc<-read.table(mth)
    TE_type<-read.table(TE_type)
    levs<-levels(TE_type[,1])
    color<-2:6
    flag<-0
    for(i in levs){
        if(flag == 0){
            plot(cc[cc[,1] == i,][,3],cc[cc[,1] == i,][,4],ylim=range(0,cc[,4]),col=color[flag+1],type="l", axes=FALSE, xlab = "", ylab = "" , main = contxt)
    }else{
        lines(cc[cc[,1] == i,][,3], cc[cc[,1] == i,][,4],col=color[flag+1])}
        flag<-flag+1
    }
    axis(2)
    axis(1,labels=FALSE,tick=FALSE)
    mtext(class,side=1,line=0.5)
    mtext(c("Methylation Level(%)"),side=2,line=2)
    abline(v=-0,lty = "dashed")
    abline(v=19,lty = "dashed")
    box()
    legend("topleft", levs , cex=1, col = color , lty=1) 
}
