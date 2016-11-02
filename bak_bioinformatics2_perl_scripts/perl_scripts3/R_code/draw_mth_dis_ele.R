draw_mth_dis_ele<-function(cpg,contxt){
    cpg<-read.table(cpg)
    cpg<-cpg[order(cpg[,2]),]
   
    plot(1:100,cpg[cpg[,1]=="upstream",][,3],type="l",ylim=c(min(cpg[,3]),max(cpg[,3])),xlim=c(0,700),col="red",xlab="",ylab="",main=contxt,axes=FALSE)
   
    axis(2)
    axis(1,label=FALSE)
    mtext(c("US","FE","FI","IE","II","LE","DS"),at=c(50,150,250,350,450,550,650),side=1,line=0.5)
    mtext(c("Methylation Level(100%)"),side=2,line=2)
    box();  

    lines(101:200,cpg[cpg[,1]=="first_exon",][,3],col="red")
    lines(201:300,cpg[cpg[,1]=="first_intron",][,3],col="red")
    lines(301:400,cpg[cpg[,1]=="internal_exon",][,3],col="red")
    lines(401:500,cpg[cpg[,1]=="internal_intron",][,3],col="red")
    lines(501:600,cpg[cpg[,1]=="last_exon",][,3],col="red")
    lines(601:700,cpg[cpg[,1]=="downstream",][,3],col="red")
    abline(v=100.5,lty="dashed")
    abline(v=200.5,lty="dashed")
    abline(v=300.5,lty="dashed")
    abline(v=400.5,lty="dashed")
    abline(v=500.5,lty="dashed")
    abline(v=600.5,lty="dashed")
}
