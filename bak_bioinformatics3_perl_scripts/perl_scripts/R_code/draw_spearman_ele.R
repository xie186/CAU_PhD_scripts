draw_spearman_ele<-function(CG,CHG,CHH){
#  pdf(OUT);
 cg<-read.table(CG);
 cg<-cg[order(cg[,2]),]
 chg<-read.table(CHG);
 chg<-chg[order(chg[,2]),]
 chh<-read.table(CHH);
 chh<-chh[order(chh[,2]),]
 max<-max(cg[,5],chg[,5],chh[,5]);min<-min(cg[,5],chg[,5],chh[,5]);
 
    plot(1:100,cg[cg[,1]=="upstream",][,5],type="l",xlim=c(0,700),ylim=c(min,max),col="red",xlab="Gene Model",ylab="r of Spearman' Correlation"); 
    lines(101:200,cg[cg[,1]=="first_exon",][,5],col="red")
    lines(201:300,cg[cg[,1]=="first_intron",][,5],col="red")
    lines(301:400,cg[cg[,1]=="internal_exon",][,5],col="red")
    lines(401:500,cg[cg[,1]=="internal_intron",][,5],col="red")
    lines(501:600,cg[cg[,1]=="last_exon",][,5],col="red")
    lines(601:700,cg[cg[,1]=="downstream",][,5],col="red")
   

    lines(1:100,chg[chg[,1]=="upstream",][,5],col="RoyalBlue");
    lines(101:200,chg[chg[,1]=="first_exon",][,5],col="RoyalBlue")
    lines(201:300,chg[chg[,1]=="first_intron",][,5],col="RoyalBlue")
    lines(301:400,chg[chg[,1]=="internal_exon",][,5],col="RoyalBlue")
    lines(401:500,chg[chg[,1]=="internal_intron",][,5],col="RoyalBlue")
    lines(501:600,chg[chg[,1]=="last_exon",][,5],col="RoyalBlue")
    lines(601:700,chg[chg[,1]=="downstream",][,5],col="RoyalBlue") 
    
    lines(1:100,chh[chh[,1]=="upstream",][,5],col="PaleGreen4");
    lines(101:200,chh[chh[,1]=="first_exon",][,5],col="PaleGreen4");
    lines(201:300,chh[chh[,1]=="first_intron",][,5],col="PaleGreen4");
    lines(301:400,chh[chh[,1]=="internal_exon",][,5],col="PaleGreen4");
    lines(401:500,chh[chh[,1]=="internal_intron",][,5],col="PaleGreen4")
    lines(501:600,chh[chh[,1]=="last_exon",][,5],col="PaleGreen4")
    lines(601:700,chh[chh[,1]=="downstream",][,5],col="PaleGreen4") 
    
#  segments(0,0,140,0,lwd=2);
  
   abline(v=100.5,lty="dashed");
   abline(v=200.5,lty="dashed");
   abline(v=300.5,lty="dashed");
   abline(v=400.5,lty="dashed");
   abline(v=500.5,lty="dashed");
   abline(v=600.5,lty="dashed");

#  legend(60,max,c("CpG","CHG","CHH"),cex=0.8,col=c("red","RoyalBlue","PaleGreen4"),pch=".");
#    dev.off()
}
