DMS_dis_TE <- function(cpg,chg,PDF){
    pdf(PDF,width = 3.6,height=4)
    cpg <- read.table(cpg)
    chg <- read.table(chg)
    max<-max(cpg[,3],chg[,3]);
    plot(cpg[,3],type="l",ylim=c(0,max),col = rgb(74,126,187,max=255), lwd=2,xlab="",ylab="",axes=FALSE,main = "");
    lines(chg[,3], col = rgb(190,75,72,max=255),lwd=2); 
    abline(v=20.5,lty="dashed");
    abline(v=80.5,lty="dashed");
    axis(2)
    axis(1,labels=FALSE,at=c(0,20.5,80.5,100))
    mtext(c("-2k"),side=1,at = c(10),line=0.5) 
    mtext(c("2k"),side=1,at = c(90),line=0.5)
    mtext(c("TE"),side=1,line=0.5)
    mtext(c("# of DMSs per 1000 cytosines"),side=2,line=2)
#    box() 
    legend(20,max*0.9*100,c("CG","CHG"),cex=0.8,col=c(rgb(74,126,187,max=255),rgb(190,75,72,max=255)), lty=1, lwd = 2);
    dev.off();
}


Args <- commandArgs();
cat("Useage: R --vanilla --slave --input_CpG <input> --input_CHG <input> --output <pdf> < DMS_dis_TE.R", "\n");

cat (Args,"\n")
for (i in 1:length(Args)) {
        if (Args[i] == "--input_CpG")  cpg = Args[i+1]
        if (Args[i] == "--input_CHG")  chg = Args[i+1]
        if (Args[i] == "--output") output = Args[i+1]
}

cc <- DMS_dis_TE(cpg,chg,output)
