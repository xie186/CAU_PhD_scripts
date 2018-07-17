meth_dis_gene_tis<-function(maternal,paternal,context, tis1, tis2, PDF){
    pdf(PDF,width = 3.6,height = 4);
    mat <- read.table(maternal);
    pat <- read.table(paternal); 
    max<-max(mat[,3],pat[,3]);
    plot(mat[,3]*100,type="l",ylim=c(0,max*100),col = rgb(74,126, 187,96,160,max = 255), axes = FALSE,lwd=1.5,xlab="",ylab="");  ## blue
    lines(pat[,3]*100, col = rgb(190,75,72,max = 255), lwd=1.5);  ## purple
    axis(2)
    axis(1,labels=FALSE,at=c(0,20.5,80.5,100))
    mtext(c("-2k"),side=1,at = c(10),line=0.5)
    mtext(c("2k"),side=1,at = c(90),line=0.5)
    mtext(context,side=1,line=0.5)
    mtext(c("Methylation Level(%)"),side=2,line=2)
    
    abline(v=20.5,lty="dashed");
    abline(v=80.5,lty="dashed");
    legend(1,max*0.9*100, c(tis1,tis2), cex=0.8, col=c(rgb(74,126, 187,96,160,max = 255), rgb(190,75,72,max = 255)), pch=".",lty=1, ,lwd=2);
    dev.off();
}
