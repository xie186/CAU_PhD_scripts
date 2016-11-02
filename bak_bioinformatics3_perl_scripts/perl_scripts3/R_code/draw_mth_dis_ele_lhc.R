draw_mth_dis_ele<-function(cpg_lc,cpg_hc,contxt){
    cpg_lc<-read.table(cpg_lc)
    cpg_lc<-cpg_lc[order(cpg_lc[,2]),]
    cpg_hc<-read.table(cpg_hc)
    cpg_hc<-cpg_hc[order(cpg_hc[,2]),]
    rang<-range(0,cpg_lc[,3],cpg_hc[,3])     

    plot(1:100,cpg_lc[cpg_lc[,1]=="upstream",][,3],type="l",ylim=rang,xlim=c(0,700),col="red",xlab="",ylab="",axes=FALSE,main=contxt)
    
    axis(2)
    axis(1,label=FALSE)
    mtext(c("US","FE","FI","IE","II","LE","DS"),at=c(50,150,250,350,450,550,650),side=1,line=0.5)
    mtext(c("Methylation Level(100%)"),side=2,line=2)
    box();
   
    lines(101:200,cpg_lc[cpg_lc[,1]=="first_exon",][,3],col="red")
    lines(201:300,cpg_lc[cpg_lc[,1]=="first_intron",][,3],col="red")
    lines(301:400,cpg_lc[cpg_lc[,1]=="internal_exon",][,3],col="red")
    lines(401:500,cpg_lc[cpg_lc[,1]=="internal_intron",][,3],col="red")
    lines(501:600,cpg_lc[cpg_lc[,1]=="last_exon",][,3],col="red")
    lines(601:700,cpg_lc[cpg_lc[,1]=="downstream",][,3],col="red")
    
    lines(1:100,cpg_hc[cpg_hc[,1]=="upstream",][,3],col="royalblue")
    lines(101:200,cpg_hc[cpg_hc[,1]=="first_exon",][,3],col="royalblue")
    lines(201:300,cpg_hc[cpg_hc[,1]=="first_intron",][,3],col="royalblue")
    lines(301:400,cpg_hc[cpg_hc[,1]=="internal_exon",][,3],col="royalblue")
    lines(401:500,cpg_hc[cpg_hc[,1]=="internal_intron",][,3],col="royalblue")
    lines(501:600,cpg_hc[cpg_hc[,1]=="last_exon",][,3],col="royalblue")
    lines(601:700,cpg_hc[cpg_hc[,1]=="downstream",][,3],col="royalblue")   
 
    abline(v=100.5,lty="dashed")
    abline(v=200.5,lty="dashed")
    abline(v=300.5,lty="dashed")
    abline(v=400.5,lty="dashed")
    abline(v=500.5,lty="dashed")
    abline(v=600.5,lty="dashed")
}
