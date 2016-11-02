draw_spearman<-function(CG,CHG,CHH,OUT){
 pdf(OUT);
 cg<-read.table(CG);
 chg<-read.table(CHG);
 chh<-read.table(CHH);
 max<-max(cg[,3],chg[,3],chh[,3]);min<-min(cg[,3],chg[,3],chh[,3]);
 plot(cg[,3],type="l",ylim=c(min,max),col="red",xlab="Gene Model",ylab="r of Spearman' Correlation");
 lines(chh[,3],col="PaleGreen4");
 lines(chg[,3],col="RoyalBlue");
 segments(0,0,140,0,lwd=2);
 abline(v=20.5,lty="dashed");
 abline(v=120.5,lty="dashed");
 legend(60,max,c("CpG","CHG","CHH"),cex=0.8,col=c("red","RoyalBlue","PaleGreen4"),pch=".");
 dev.off()
}
