meth_dis_gene_RPKM<-function(S,PDF){
    pdf(PDF);
    cc<-read.table(S);
    max<-max(cc[,3],cc[,4],cc[,5],cc[,6],cc[,7]);
    plot(cc[,3],type="l",ylim=c(0,max));
    lines(cc[,4],col="red");
    lines(cc[,5],col="blue");
    lines(cc[,6],col="IndianRed4");
    lines(cc[,7],col="Chocolate");
    abline(v=20.5,lty="dashed");
    abline(v=120.5,lty="dashed");
    legend(1,max*0.9,c("Top 20%","20-40%","40-60%","60-80%","80-100%"),cex=0.8,col=c("Chocolate","IndianRed4","blue","red","black"),pch=".",lty=1:2);
    dev.off();
}
