meth_dis_gene_RPKM10<-function(S,PDF){
    pdf(PDF);
    cc<-read.table(S);
    
    max<-max(cc[,3],cc[,4],cc[,5],cc[,6],cc[,7],cc[,8],cc[,9],cc[,10],cc[,11],cc[,12]);
    plot(cc[,3],type="l",ylim=c(0,max));
    lines(cc[,4],col="red");
    lines(cc[,5],col="blue");
    lines(cc[,6],col="IndianRed4");
    lines(cc[,7],col="Chocolate");
    lines(cc[,8],col="purple");
    lines(cc[,9],col="LightGreen");
    lines(cc[,10],col="DarkGreen");
    lines(cc[,11],col="RoyalBlue");
    lines(cc[,12],col="DarkOrange");  
    abline(v=20.5,lty="dashed");
    abline(v=120.5,lty="dashed");
    legend(1,max*0.9,c("Top 10%","10-20%","20-30%","30-40%","40-50%","50-60","60,70","70-80","80-90","90-100"),cex=0.8,col=c("DarkOrange","RoyalBlue","DarkGreen","LightGreen","purple","Chocolate","IndianRed4","blue","red","black"),pch=".",lty=1:2);
    dev.off();
}
