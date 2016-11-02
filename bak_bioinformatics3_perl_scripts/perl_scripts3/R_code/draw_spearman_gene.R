draw_spearman_gene<-function(cpg,chg,chh,clas){

    cpg<-read.table(cpg)
    chg<-read.table(chg)
    chh<-read.table(chh)    

    rang<-range(cpg[,3],chg[,3],chh[,3])
    plot(cpg[,3],type="l",ylim=rang,axes=FALSE,xlab="",ylab="",main=clas,col="red")
    for(i in 1:length(cpg[,2])){
        if(cpg[i,2]<=0.01){
           points(i,cpg[i,3],col="red")
        }
    }

    lines(chg[,3],col="RoyalBlue")
    for(i in 1:length(chg[,2])){
        if(chg[i,2]<=0.01){
           points(i,chg[i,3],col="RoyalBlue")
        }
    }
     
    lines(chh[,3],col="PaleGreen4")
    for(i in 1:length(chh[,2])){
        if(chh[i,2]<=0.01){
           points(i,chh[i,3],col="PaleGreen4")
        }
    }
    
    abline(v=20.5,lty="dashed",col="grey");
    abline(v=120.5,lty="dashed",col="grey");
    abline(h=0,lty="dashed",col="grey")
    axis(2)
    axis(1,labels=FALSE,tick=FALSE)
    mtext(c("Gene Body"),side=1,line=0.5)
    mtext(c("Spearman correlation's r"),side=2,line=2)
    box()
}
