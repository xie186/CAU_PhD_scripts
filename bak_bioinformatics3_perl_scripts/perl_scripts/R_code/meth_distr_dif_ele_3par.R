meth_dis_dif_ele_3par<-function(cpg,CG,chg,CHG,chh,CHH,OUT){
    pdf(OUT)
    #exp 
    cpg<-read.table(cpg)
    cpg<-cpg[order(cpg[,2]),]
    chg<-read.table(chg)
    chg<-chg[order(chg[,2]),]
    chh<-read.table(chh)
    chh<-chh[order(chh[,2]),]
    #no exp
    CG<-read.table(CG)
    CG<-CG[order(CG[,2]),]
    CHG<-read.table(CHG)
    CHG<-CHG[order(CHG[,2]),]
    CHH<-read.table(CHH)
    CHH<-CHH[order(CHH[,2]),]
    par(mfrow=c(3,1))
    #exp CpG
   
    plot(1:100,cpg[cpg[,1]=="upstream",][,3],type="l",ylim=c(min(cpg[,3],CG[,3]),max(cpg[,3],CG[,3])),xlim=c(0,700),col="red",xlab="CpG",ylab="Methylation Level")
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
     
    lines(1:100,CG[CG[,1]=="upstream",][,3],col="RoyalBlue")
    lines(101:200,CG[CG[,1]=="first_exon",][,3],col="RoyalBlue")
    lines(201:300,CG[CG[,1]=="first_intron",][,3],col="RoyalBlue")
    lines(301:400,CG[CG[,1]=="internal_exon",][,3],col="RoyalBlue")
    lines(401:500,CG[CG[,1]=="internal_intron",][,3],col="RoyalBlue")
    lines(501:600,CG[CG[,1]=="last_exon",][,3],col="RoyalBlue")
    lines(601:700,CG[CG[,1]=="downstream",][,3],col="RoyalBlue")

    plot(1:100,chg[chg[,1]=="upstream",][,3],type="l",ylim=c(min(chg[,3],CHG[,3]),max(chg[,3],CHG[,3])),xlim=c(0,700),col="red",xlab="CHG",ylab="Methylation Level")
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

    lines(1:100,CHG[CHG[,1]=="upstream",][,3],col="RoyalBlue")
    lines(101:200,CHG[CHG[,1]=="first_exon",][,3],col="RoyalBlue")
    lines(201:300,CHG[CHG[,1]=="first_intron",][,3],col="RoyalBlue")
    lines(301:400,CHG[CHG[,1]=="internal_exon",][,3],col="RoyalBlue")
    lines(401:500,CHG[CHG[,1]=="internal_intron",][,3],col="RoyalBlue")
    lines(501:600,CHG[CHG[,1]=="last_exon",][,3],col="RoyalBlue")
    lines(601:700,CHG[CHG[,1]=="downstream",][,3],col="RoyalBlue")
    
    plot(1:100,chh[chh[,1]=="upstream",][,3],type="l",ylim=c(min(chh[,3],CHH[,3]),max(chh[,3],CHH[,3])),xlim=c(0,700),col="red",xlab="CHH",ylab="Methylation Level")
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

    lines(1:100,CHH[CHH[,1]=="upstream",][,3],col="RoyalBlue")
    lines(101:200,CHH[CHH[,1]=="first_exon",][,3],col="RoyalBlue")
    lines(201:300,CHH[CHH[,1]=="first_intron",][,3],col="RoyalBlue")
    lines(301:400,CHH[CHH[,1]=="internal_exon",][,3],col="RoyalBlue")
    lines(401:500,CHH[CHH[,1]=="internal_intron",][,3],col="RoyalBlue")
    lines(501:600,CHH[CHH[,1]=="last_exon",][,3],col="RoyalBlue")
    lines(601:700,CHH[CHH[,1]=="downstream",][,3],col="RoyalBlue")
    dev.off()
}
