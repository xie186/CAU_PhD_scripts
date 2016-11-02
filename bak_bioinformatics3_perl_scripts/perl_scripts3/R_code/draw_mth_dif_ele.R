draw_mth_dif_ele<-function(cpg,chg,chh){
    #exp 
    cpg<-read.table(cpg)
    cpg<-cpg[order(cpg[,2]),]
    chg<-read.table(chg)
    chg<-chg[order(chg[,2]),]
    chh<-read.table(chh)
    chh<-chh[order(chh[,2]),]
    par(mfrow=c(3,1))
    #exp CpG
   
    plot(1:100,cpg[cpg[,1]=="upstream",][,3],type="l",ylim=c(min(cpg[,3]),max(cpg[,3])),xlim=c(0,700),col="red",xlab="CpG",ylab="Methylation Level")
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

    plot(1:100,chg[chg[,1]=="upstream",][,3],type="l",ylim=c(min(chg[,3]),max(chg[,3])),xlim=c(0,700),col="red",xlab="CHG",ylab="Methylation Level")
    lines(101:200,chg[chg[,1]=="first_exon",][,3],col="red")
    lines(201:300,chg[chg[,1]=="first_intron",][,3],col="red")
    lines(301:400,chg[chg[,1]=="internal_exon",][,3],col="red")
    lines(401:500,chg[chg[,1]=="internal_intron",][,3],col="red")
    lines(501:600,chg[chg[,1]=="last_exon",][,3],col="red")
    lines(601:700,chg[chg[,1]=="downstream",][,3],col="red")
    abline(v=100.5,lty="dashed")
    abline(v=200.5,lty="dashed")
    abline(v=300.5,lty="dashed")
    abline(v=400.5,lty="dashed")
    abline(v=500.5,lty="dashed")
    abline(v=600.5,lty="dashed")
    
    plot(1:100,chh[chh[,1]=="upstream",][,3],type="l",ylim=c(min(chh[,3]),max(chh[,3])),xlim=c(0,700),col="red",xlab="CHH",ylab="Methylation Level")
    lines(101:200,chh[chh[,1]=="first_exon",][,3],col="red")
    lines(201:300,chh[chh[,1]=="first_intron",][,3],col="red")
    lines(301:400,chh[chh[,1]=="internal_exon",][,3],col="red")
    lines(401:500,chh[chh[,1]=="internal_intron",][,3],col="red")
    lines(501:600,chh[chh[,1]=="last_exon",][,3],col="red")
    lines(601:700,chh[chh[,1]=="downstream",][,3],col="red")
    abline(v=100.5,lty="dashed")
    abline(v=200.5,lty="dashed")
    abline(v=300.5,lty="dashed")
    abline(v=400.5,lty="dashed")
    abline(v=500.5,lty="dashed")
    abline(v=600.5,lty="dashed")

}
