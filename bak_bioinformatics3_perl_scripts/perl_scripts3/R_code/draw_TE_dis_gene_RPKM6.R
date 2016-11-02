draw_TE_dis_gene_RPKM6<-function(S,contxt){

    cc<-read.table(S);    
    max<-max(cc[,2],cc[,3],cc[,4],cc[,5],cc[,6],cc[,7])
    plot(lowess(cc[,2],f=0.03),type="l",ylim=c(0,max),main=contxt,axes=FALSE,xlab="",ylab="",col="black")
    lines(lowess(cc[,3],f=0.03),col="DarkGreen")
    lines(lowess(cc[,4],f=0.03),col="red")
    lines(lowess(cc[,5],f=0.03),col="blue")
    lines(lowess(cc[,6],f=0.03),col="IndianRed4")
    lines(lowess(cc[,7],f=0.03),col="Chocolate")
    abline(v=20.5,lty="dashed")
    abline(v=120.5,lty="dashed")
    axis(1,labels=FALSE,tick=FALSE)
    axis(2)
    mtext(c("Gene"),line=0.5,side=1)
    mtext(c("Methylation level(%)"),line=2,side=2)
    box()
#    legend(1,max*0.9,c("Top 10%","10-20%","20-30%","30-40%","40-50%","50-60","60,70","70-80","80-90","90-100"),cex=0.8,col=c("DarkOrange","RoyalBlue","DarkGreen","LightGreen","purple","Chocolate","IndianRed4","blue","red","black"),pch=".",lty=1:2);
}
