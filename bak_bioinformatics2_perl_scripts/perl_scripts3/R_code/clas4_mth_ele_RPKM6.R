draw_mth_dis_dif_ele_dif_RPKM5<-function(CG,contxt){
     cg<-read.table(CG)
     cg<-cg[order(cg[,2]),]
     rang<-range(0,cg[,3],cg[,4],cg[,5],cg[,6],cg[,7],cg[,8]);
    
     plot(1:100,cg[cg[,1]=="upstream",][,4],type="l",xlim=c(0,700),ylim=rang,xlab="",ylab="",col="DarkGreen",axes=FALSE,main=contxt)
     axis(2)
     axis(1,label=FALSE)
     mtext(c("US","FE","FI","IE","II","LE","DS"),at=c(50,150,250,350,450,550,650),side=1,line=0.5)
     mtext(c("Methylation level(%)"),side=2,line=2)
     box();
     lines(1:100,cg[cg[,1]=="upstream",][,3],col="black")
     lines(1:100,cg[cg[,1]=="upstream",][,5],col="red")
     lines(1:100,cg[cg[,1]=="upstream",][,6],col="blue")
     lines(1:100,cg[cg[,1]=="upstream",][,7],col="IndianRed4")
     lines(1:100,cg[cg[,1]=="upstream",][,8],col="Chocolate")
    
    ele<-c("first_exon","first_intron","internal_exon","internal_intron","last_exon","downstream")
    for(i in 1:length(ele)){
         stt<-100*i+1;
         ed <-100*(i+1) 
         lines(stt:ed,cg[cg[,1]==ele[i],][,3],col="black")
         lines(stt:ed,cg[cg[,1]==ele[i],][,4],col="DarkGreen")
         lines(stt:ed,cg[cg[,1]==ele[i],][,5],col="red") 
         lines(stt:ed,cg[cg[,1]==ele[i],][,6],col="blue")
         lines(stt:ed,cg[cg[,1]==ele[i],][,7],col="IndianRed4")
         lines(stt:ed,cg[cg[,1]==ele[i],][,8],col="Chocolate")
     }
     abline(v=100.5,lty="dashed")
     abline(v=200.5,lty="dashed")
     abline(v=300.5,lty="dashed")
     abline(v=400.5,lty="dashed")
     abline(v=500.5,lty="dashed")
     abline(v=600.5,lty="dashed")
}
