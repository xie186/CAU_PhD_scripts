DMS_dis_gene <- function(cpg,chg,PDF){
    pdf(PDF,width = 3.6,height=4)
    cpg <- read.table(cpg)
    chg <- read.table(chg)
    max<-max(cpg[,3],chg[,3]);
    p_cpg<-lowess(cpg[,4]/(cpg[,3]+cpg[,4]),f=0.05)
    plot(p_cpg,type="l",ylim=c(0,1),col = rgb(74,126,187,max=255), lwd=2,xlab="",ylab="",axes=FALSE,main = "");
    p_chg<-lowess(chg[,4]/(chg[,3]+chg[,4]),f=0.05)
    lines(p_chg, col = rgb(190,75,72,max=255),lwd=2); 
    abline(h=0.5,lty="dashed");
    abline(v=20.5,lty="dashed");
    abline(v=80.5,lty="dashed");
    axis(2)
    axis(1,labels=FALSE,at=c(0,20.5,80.5,100))
    mtext(c("-2k"),side=1,at = c(10),line=0.5) 
    mtext(c("2k"),side=1,at = c(90),line=0.5)
    mtext(c("Gene"),side=1,line=0.5)
    mtext(c("Ratio of DMSs in cluster"),side=2,line=2)
#    box() 
    legend(20,max*0.9*100,c("cpg","chg"),cex=0.8,col=c(rgb(74,126,187,max=255),rgb(190,75,72,max=255)), lty=1, lwd = 2);
    dev.off();
}


Args <- commandArgs();
cat("Useage: R --vanilla --slave --input_CpG <input> --input_CHG <input> --output <pdf> < DMS_dis_gene.R", "\n");

cat (Args,"\n")
for (i in 1:length(Args)) {
        if (Args[i] == "--input_CpG")  cpg = Args[i+1]
        if (Args[i] == "--input_CHG")  chg = Args[i+1]
        if (Args[i] == "--output") output = Args[i+1]
}

cc <- DMS_dis_gene(cpg,chg,output)
