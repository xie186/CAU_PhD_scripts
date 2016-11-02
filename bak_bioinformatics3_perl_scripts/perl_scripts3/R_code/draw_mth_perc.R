draw_mth_perc<-function(ara,rice,zm,contxt){
    ara<-read.table(ara)
    rice<-read.table(rice)
    zm<-read.table(zm)
     
    rang<-range(0,ara[,4],rice[,4],zm[,4])

    plot(ara[,4],axes=FALSE,main=contxt,pch=".",cex=10,col="red",ylim=rang,xlab="Methylation Level(%)",ylab="Fraction of Total Cytocine")
    lines(ara[,4],col="red")
   
    par(new=T) 
    plot(rice[,4],axes=FALSE,pch=".",cex=10,col="royalblue",ylim=rang,xlab="",ylab="") 
    lines(rice[,4],col="royalblue")
    
    par(new=T)
    plot(zm[,4],axes=FALSE,pch=".",cex=10,col="darkgreen",ylim=rang,xlab="",ylab="")
    lines(zm[,4],col="darkgreen")
    
    axis(2)
    axis(1,labels=FALSE,at=c(1,2,3,4,5,6,7,8,9,10))
    
    box()
    text(1:10,-0.1,srt=45,adj=0.5,labels=c("0-10","10-20","20-30","30-40","40-50","50-60","60-70","70-80","80-90","90-100"),xpd=T)
#    mtext(c("0-10","10-20","20-30","30-40","40-50","50-60","60-70","70-80","80-90","90-100"),at=c(1,2,3,4,5,6,7,8,9,10),line=1,side=1)

}
