draw_mth_dis_ele_dif_RPKM_smooth<-function(CG,OUT){
   pdf(OUT);
   cg<-read.table(CG);
   cg<-cg[order(cg[,2]),]
   max<-max(cg[,3],cg[,4],cg[,5],cg[,6],cg[,7]);
    
    plot(1:101,cg[cg[,1]=="upstream",][,3],type="l",xlim=c(0,707),ylim=c(0,max),xlab="Gene Model",ylab="Methylation level")
    lines(1:101,cg[cg[,1]=="upstream",][,4],col="red")
    lines(1:101,cg[cg[,1]=="upstream",][,5],col="blue")
    lines(1:101,cg[cg[,1]=="upstream",][,6],col="IndianRed4")
    lines(1:101,cg[cg[,1]=="upstream",][,7],col="Chocolate")

   lines(102:202,cg[cg[,1]=="first_exon",][,3])
   lines(102:202,cg[cg[,1]=="first_exon",][,4],col="red") 
   lines(102:202,cg[cg[,1]=="first_exon",][,5],col="blue")
   lines(102:202,cg[cg[,1]=="first_exon",][,6],col="IndianRed4")
   lines(102:202,cg[cg[,1]=="first_exon",][,7],col="Chocolate")

    lines(203:303,cg[cg[,1]=="first_intron",][,3]);
    lines(203:303,cg[cg[,1]=="first_intron",][,4],col="red");
    lines(203:303,cg[cg[,1]=="first_intron",][,5],col="blue");
    lines(203:303,cg[cg[,1]=="first_intron",][,6],col="IndianRed4");
    lines(203:303,cg[cg[,1]=="first_intron",][,7],col="Chocolate");
     
     lines(304:404,cg[cg[,1]=="internal_exon",][,3]);
     lines(304:404,cg[cg[,1]=="internal_exon",][,4],col="red");
     lines(304:404,cg[cg[,1]=="internal_exon",][,5],col="blue");
     lines(304:404,cg[cg[,1]=="internal_exon",][,6],col="IndianRed4");
     lines(304:404,cg[cg[,1]=="internal_exon",][,7],col="Chocolate");

     lines(405:505,cg[cg[,1]=="internal_intron",][,3]);
     lines(405:505,cg[cg[,1]=="internal_intron",][,4],col="red");
     lines(405:505,cg[cg[,1]=="internal_intron",][,5],col="blue");
     lines(405:505,cg[cg[,1]=="internal_intron",][,6],col="IndianRed4");
     lines(405:505,cg[cg[,1]=="internal_intron",][,7],col="Chocolate");
 
     lines(506:606,cg[cg[,1]=="last_exon",][,3]);
     lines(506:606,cg[cg[,1]=="last_exon",][,4],col="red");
     lines(506:606,cg[cg[,1]=="last_exon",][,5],col="blue");
     lines(506:606,cg[cg[,1]=="last_exon",][,6],col="IndianRed4");
     lines(506:606,cg[cg[,1]=="last_exon",][,7],col="Chocolate");
     
     lines(607:707,cg[cg[,1]=="downstream",][,3])
     lines(607:707,cg[cg[,1]=="downstream",][,4],col="red")
     lines(607:707,cg[cg[,1]=="downstream",][,5],col="blue")
     lines(607:707,cg[cg[,1]=="downstream",][,6],col="IndianRed4")
     lines(607:707,cg[cg[,1]=="downstream",][,7],col="Chocolate")  
      
      abline(v=101.5,lty="dashed")
      abline(v=202.5,lty="dashed")
      abline(v=303.5,lty="dashed")
      abline(v=404.5,lty="dashed")
      abline(v=505.5,lty="dashed")
      abline(v=707.5,lty="dashed")
      abline(v=606.5,lty="dashed")

      dev.off()
}
