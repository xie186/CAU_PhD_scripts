meth_dis_gene_RPKM5<-function(S,contxt){
    cc<-read.table(S);
    
    max<-max(cc[,3],cc[,4],cc[,5],cc[,6],cc[,7]);
    plot(cc[,3],type="l",ylim=c(0,max),main=contxt,axes=FALSE,xlab="",ylab="",col="DarkGreen");
    lines(cc[,4],col="red");
    lines(cc[,5],col="blue");
    lines(cc[,6],col="IndianRed4");
    lines(cc[,7],col="Chocolate");
    abline(v=20.5,lty="dashed");
    abline(v=120.5,lty="dashed");
    axis(1,labels=FALSE,tick=FALSE)
    axis(2)
    mtext(c("Gene Body"),line=0.5,side=1)
    mtext(c("Methylation Level(%)"),line=2,side=2)
    box()
#    legend(1,max*0.9,c("Top 10%","10-20%","20-30%","30-40%","40-50%","50-60","60,70","70-80","80-90","90-100"),cex=0.8,col=c("DarkOrange","RoyalBlue","DarkGreen","LightGreen","purple","Chocolate","IndianRed4","blue","red","black"),pch=".",lty=1:2);
}
