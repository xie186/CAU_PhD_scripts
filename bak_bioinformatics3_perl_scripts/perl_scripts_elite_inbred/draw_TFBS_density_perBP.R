draw_TFBS_density_perBP <- function(infile,out){
    pdf(out, width = 4, height = 4)
    cc<-read.table(infile);
    rownames(cc)<-cc[,1];
    cc<-cc[-1];
    barplot(t(cc),xaxt="n",col="royalblue",space=0.2, width = 0.8);
    text(0.5:9.5,0,srt=45, adj=1, labels=rownames(cc),xpd=T, cex=0.8);
    dev.off()
}

Args<-commandArgs();

cat("Usage: R --vanilla --slave --input --output < draw_TFBS_density_perBP.R")
cat(Args, "\n")
for(i in 1:length(Args)){
    if(Args[i] == "--input") infile = Args[i+1]
    if(Args[i] == "--output") outfile = Args[i+1]
}

draw_TFBS_density_perBP(infile, outfile)
