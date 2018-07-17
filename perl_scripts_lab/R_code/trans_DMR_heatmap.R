heatmap <- function(cpg,PDF){

   pdf(PDF,height=5,width=3.5)
   cc<-read.table(cpg,header=T)
   library(gplots)
   x  <- as.matrix(cc)
   heatmap.2(x, col= colorpanel(100,low="lightyellow",mid="darkred",high="black"), keysize=2, trace = "none", density.info=c("none"), labRow=FALSE, Colv = F, dendrogram = c("row"),margins=c(10,0))
   dev.off()
}


Args <- commandArgs();
cat("Useage: R --vanilla --slave --input --output < trans_DMS_heatmap.R", "\n");

cat (Args,"\n")
for (i in 1:length(Args)) {
        if (Args[i] == "--input")  cpg = Args[i+1]
        if (Args[i] == "--output") output = Args[i+1]
}

cc <- heatmap(cpg,output)

