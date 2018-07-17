heatmap <- function(cpg,PDF){
   
   pdf(PDF,height=5,width=4);
   cc<-read.table(cpg,header=T)
   library(gplots)
   x  <- as.matrix(cc)
   #rc <- rainbow(nrow(x), start=0, end=.3)
   #cc <- rainbow(ncol(x), start=0, end=.3)
#   heatmap.2(x, col=redgreen(75), trace = "none", density.info=c("none"), labRow=FALSE, dendrogram = c("row"),margins=c(9,0))
   heatmap.2(x, col=bluered(75), trace = "none", density.info=c("none"), labRow=FALSE, Colv = F, dendrogram = c("row"),margins=c(10,0))
   dev.off()
}


Args <- commandArgs();
cat("Useage: R --vanilla --slave --input <input> --output <pdf> < trans_DMS_heatmap.R", "\n");

cat (Args,"\n")
for (i in 1:length(Args)) {
        if (Args[i] == "--input")  cpg = Args[i+1]
        if (Args[i] == "--output") output = Args[i+1]
}

cc <- heatmap(cpg,output)
