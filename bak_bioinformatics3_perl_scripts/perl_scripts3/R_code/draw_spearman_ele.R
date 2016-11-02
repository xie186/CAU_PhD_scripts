draw_spearman_ele<-function(CG,CHG,CHH,clas){
#  pdf(OUT);
    cg<-read.table(CG);
    cg<-cg[order(cg[,2]),]
    chg<-read.table(CHG);
    chg<-chg[order(chg[,2]),]
    chh<-read.table(CHH);
    chh<-chh[order(chh[,2]),]
    rang<-range(cg[,4],chg[,4],chh[,4]);
     
    cat("Here\n")
    plot(1:100,cg[cg[,1]=="upstream",][,4],type="l",xlim=c(0,700),ylim=c(-0.25,0.1),col="red",xlab="Gene Model",ylab="r of Spearman' Correlation",axes=FALSE,main=clas)
    cat ("Hello!!!\n")
    lines(101:200,cg[cg[,1]=="first_exon",][,4],col="red")
    lines(201:300,cg[cg[,1]=="first_intron",][,4],col="red")
    lines(301:400,cg[cg[,1]=="internal_exon",][,4],col="red")
    lines(401:500,cg[cg[,1]=="internal_intron",][,4],col="red")
    lines(501:600,cg[cg[,1]=="last_exon",][,4],col="red")
    lines(601:700,cg[cg[,1]=="downstream",][,4],col="red")
    ele<-c("upstream","first_exon","first_intron","internal_exon","internal_intron","last_exon","downstream")
    for(i in 1:length(ele)){
        for(j in 1:length(cg[cg[,1]==ele[i],][,1])){
            coor<-(i-1)*100+j
            if(cg[cg[,1]==ele[i],][j,3] <= 0.01){
                points(coor,cg[cg[,1]==ele[i],][j,4],col="red")
            }
        }
    }

    lines(1:100,chg[chg[,1]=="upstream",][,4],col="RoyalBlue");
    lines(101:200,chg[chg[,1]=="first_exon",][,4],col="RoyalBlue")
    lines(201:300,chg[chg[,1]=="first_intron",][,4],col="RoyalBlue")
    lines(301:400,chg[chg[,1]=="internal_exon",][,4],col="RoyalBlue")
    lines(401:500,chg[chg[,1]=="internal_intron",][,4],col="RoyalBlue")
    lines(501:600,chg[chg[,1]=="last_exon",][,4],col="RoyalBlue")
    lines(601:700,chg[chg[,1]=="downstream",][,4],col="RoyalBlue") 
    for(i in 1:length(ele)){
        for(j in 1:length(chg[chg[,1]==ele[i],][,1])){
            coor<-(i-1)*100+j
            if(chg[chg[,1]==ele[i],][j,3] <= 0.01){
                points(coor,chg[chg[,1]==ele[i],][j,4],col="RoyalBlue")
            }
        }
    }
    
    lines(1:100,chh[chh[,1]=="upstream",][,4],col="PaleGreen4");
    lines(101:200,chh[chh[,1]=="first_exon",][,4],col="PaleGreen4");
    lines(201:300,chh[chh[,1]=="first_intron",][,4],col="PaleGreen4");
    lines(301:400,chh[chh[,1]=="internal_exon",][,4],col="PaleGreen4");
    lines(401:500,chh[chh[,1]=="internal_intron",][,4],col="PaleGreen4")
    lines(501:600,chh[chh[,1]=="last_exon",][,4],col="PaleGreen4")
    lines(601:700,chh[chh[,1]=="downstream",][,4],col="PaleGreen4") 
    for(i in 1:length(ele)){
        for(j in 1:length(chh[chh[,1]==ele[i],][,1])){
            coor<-(i-1)*100+j
            if(chh[chh[,1]==ele[i],][j,3] <= 0.01){
                points(coor,chh[chh[,1]==ele[i],][j,4],col="PaleGreen4")
            }
        }
    } 
#  segments(0,0,140,0,lwd=2);
  
   abline(v=100.5,lty="dashed");
   abline(v=200.5,lty="dashed");
   abline(v=300.5,lty="dashed");
   abline(v=400.5,lty="dashed");
   abline(v=500.5,lty="dashed");
   abline(v=600.5,lty="dashed");
   abline(h=0,lty="dashed")
   axis(2)
   axis(1,labels=FALSE,tick=FALSE)
   mtext(c("US","FE","FI","IE","II","LE","DS"),at=c(50,150,250,350,450,550,650),side=1,line=1)
   box() 
#  legend(60,max,c("CpG","CHG","CHH"),cex=0.8,col=c("red","RoyalBlue","PaleGreen4"),pch=".");
#    dev.off()
}
