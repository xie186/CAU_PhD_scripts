draw_trans_DMS_clus_closest_FGS <- function(input, out){

    pdf(out,height=4,width=3,useDingbats = FALSE);
    par(mfrow=c(1,1),mar=c(6,4,3,1));
    cc<-read.table(input);
    cc$len <- cc[,3] - cc[,2] +1;
#    boxplot(cc$V10~cc$V4,data=cc,axes=F, outline = F);
    boxplot(cc$len ~ cc$V6,data=cc,axes=F);
    axis(2);
    axis(1,labels=F);
    box();
    xlab <- levels(cc[,6]);
    text(c(1:(length(xlab))),-max(cc$len*0.15),labels=levels(cc[,6]),srt=45,xpd=T)
    dev.off()
}

Args <- commandArgs();
cat("usage: R --vanilla --slave --input <in> --output <out> < draw_TE_size_lap_psDMS.R")
cat(Args, "\n");
for(i in 1:length(Args)){
    if(Args[i] == "--input"){input <- Args[i + 1]}
    if(Args[i] == "--output"){out <- Args[i + 1]}
}

draw_trans_DMS_clus_closest_FGS(input, out);
