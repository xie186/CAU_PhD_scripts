draw_mth_dis_ele_RPKM10<-function(CG,OUT){
   
   pdf(OUT);
   cg<-read.table(CG);
   cg<-cg[order(cg[,2]),]
   max<-max(cg[,3],cg[,4],cg[,5],cg[,6],cg[,7],cg[,8],cg[,9],cg[,10],cg[,11],cg[,12]);
    
    plot(1:100,cg[cg[,1]=="upstream",][,3],type="l",xlim=c(0,700),ylim=c(0,max),xlab="Gene Model",ylab="Methylation level",color="black")
    lines(1:100,cg[cg[,1]=="upstream",][,4],col="red")
    lines(1:100,cg[cg[,1]=="upstream",][,5],col="blue")
    lines(1:100,cg[cg[,1]=="upstream",][,6],col="IndianRed4")
    lines(1:100,cg[cg[,1]=="upstream",][,7],col="Chocolate")
    lines(1:100,cg[cg[,1]=="upstream",][,8],col="purple")
    lines(1:100,cg[cg[,1]=="upstream",][,9],col="LightGreen")
    lines(1:100,cg[cg[,1]=="upstream",][,10],col="DarkGreen") 
    lines(1:100,cg[cg[,1]=="upstream",][,11],col="RoyalBlue")
    lines(1:100,cg[cg[,1]=="upstream",][,12],col="DarkOrange")

   lines(101:200,cg[cg[,1]=="first_exon",][,3],,color="DarkGreen")
   lines(101:200,cg[cg[,1]=="first_exon",][,4],col="red") 
   lines(101:200,cg[cg[,1]=="first_exon",][,5],col="blue")
   lines(101:200,cg[cg[,1]=="first_exon",][,6],col="IndianRed4")
   lines(101:200,cg[cg[,1]=="first_exon",][,7],col="Chocolate")
   lines(101:200,cg[cg[,1]=="first_exon",][,8],col="purple")
    lines(101:200,cg[cg[,1]=="first_exon",][,9],col="LightGreen")
    lines(101:200,cg[cg[,1]=="first_exon",][,10],col="DarkGreen")
    lines(101:200,cg[cg[,1]=="first_exon",][,11],col="RoyalBlue")
    lines(101:200,cg[cg[,1]=="first_exon",][,12],col="DarkOrange")

    lines(201:300,cg[cg[,1]=="first_intron",][,3],color="DarkGreen");
    lines(201:300,cg[cg[,1]=="first_intron",][,4],col="red");
    lines(201:300,cg[cg[,1]=="first_intron",][,5],col="blue");
    lines(201:300,cg[cg[,1]=="first_intron",][,6],col="IndianRed4");
    lines(201:300,cg[cg[,1]=="first_intron",][,7],col="Chocolate");
    lines(201:300,cg[cg[,1]=="first_intron",][,8],col="purple")
    lines(201:300,cg[cg[,1]=="first_intron",][,9],col="LightGreen")
    lines(201:300,cg[cg[,1]=="first_intron",][,10],col="DarkGreen")
    lines(201:300,cg[cg[,1]=="first_intron",][,11],col="RoyalBlue")
    lines(201:300,cg[cg[,1]=="first_intron",][,12],col="DarkOrange")
     
     lines(301:400,cg[cg[,1]=="internal_exon",][,3],color="DarkGreen");
     lines(301:400,cg[cg[,1]=="internal_exon",][,4],col="red");
     lines(301:400,cg[cg[,1]=="internal_exon",][,5],col="blue");
     lines(301:400,cg[cg[,1]=="internal_exon",][,6],col="IndianRed4");
     lines(301:400,cg[cg[,1]=="internal_exon",][,7],col="Chocolate");
     lines(301:400,cg[cg[,1]=="internal_exon",][,8],col="purple")
    lines(301:400,cg[cg[,1]=="internal_exon",][,9],col="LightGreen")
    lines(301:400,cg[cg[,1]=="internal_exon",][,10],col="DarkGreen")
    lines(301:400,cg[cg[,1]=="internal_exon",][,11],col="RoyalBlue")
    lines(301:400,cg[cg[,1]=="internal_exon",][,12],col="DarkOrange")

     lines(401:500,cg[cg[,1]=="internal_intron",][,3],color="DarkGreen");
     lines(401:500,cg[cg[,1]=="internal_intron",][,4],col="red");
     lines(401:500,cg[cg[,1]=="internal_intron",][,5],col="blue");
     lines(401:500,cg[cg[,1]=="internal_intron",][,6],col="IndianRed4");
     lines(401:500,cg[cg[,1]=="internal_intron",][,7],col="Chocolate");
     lines(401:500,cg[cg[,1]=="internal_intron",][,8],col="purple")
    lines(401:500,cg[cg[,1]=="internal_intron",][,9],col="LightGreen")
    lines(401:500,cg[cg[,1]=="internal_intron",][,10],col="DarkGreen")
    lines(401:500,cg[cg[,1]=="internal_intron",][,11],col="RoyalBlue")
    lines(401:500,cg[cg[,1]=="internal_intron",][,12],col="DarkOrange")
 
     lines(501:600,cg[cg[,1]=="last_exon",][,3],color="DarkGreen");
     lines(501:600,cg[cg[,1]=="last_exon",][,4],col="red");
     lines(501:600,cg[cg[,1]=="last_exon",][,5],col="blue");
     lines(501:600,cg[cg[,1]=="last_exon",][,6],col="IndianRed4");
     lines(501:600,cg[cg[,1]=="last_exon",][,7],col="Chocolate");
     lines(501:600,cg[cg[,1]=="last_exon",][,8],col="purple")
    lines(501:600,cg[cg[,1]=="last_exon",][,9],col="LightGreen")
    lines(501:600,cg[cg[,1]=="last_exon",][,10],col="DarkGreen")
    lines(501:600,cg[cg[,1]=="last_exon",][,11],col="RoyalBlue")
    lines(501:600,cg[cg[,1]=="last_exon",][,12],col="DarkOrange")
     
     lines(601:700,cg[cg[,1]=="downstream",][,3],color="DarkGreen")
     lines(601:700,cg[cg[,1]=="downstream",][,4],col="red")
     lines(601:700,cg[cg[,1]=="downstream",][,5],col="blue")
     lines(601:700,cg[cg[,1]=="downstream",][,6],col="IndianRed4")
     lines(601:700,cg[cg[,1]=="downstream",][,7],col="Chocolate") 
     lines(601:700,cg[cg[,1]=="downstream",][,8],col="purple")
     lines(601:700,cg[cg[,1]=="downstream",][,9],col="LightGreen")
     lines(601:700,cg[cg[,1]=="downstream",][,10],col="DarkGreen")
     lines(601:700,cg[cg[,1]=="downstream",][,11],col="RoyalBlue")
     lines(601:700,cg[cg[,1]=="downstream",][,12],col="DarkOrange") 
      
      abline(v=100.5,lty="dashed")
      abline(v=200.5,lty="dashed")
      abline(v=300.5,lty="dashed")
      abline(v=400.5,lty="dashed")
      abline(v=500.5,lty="dashed")
      abline(v=600.5,lty="dashed")
      abline(v=700.5,lty="dashed")

      dev.off()
}
