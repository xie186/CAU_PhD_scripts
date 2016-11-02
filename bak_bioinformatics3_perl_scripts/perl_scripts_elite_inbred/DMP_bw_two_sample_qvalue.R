Args <- commandArgs();

cat("Useage: R --vanilla --slave --input <input> --output <pdf> < *.R");
cat(Args,"\n");

for(i in 1:length(Args)){
    if(Args[i] == "--input")  pval <- Args[i + 1];
    if(Args[i] == "--output") out  <- Args[i + 1];
}

library(qvalue);
common<-read.table(pval);
qval <- qvalue(common[,11]);

pval <- cbind(common, qval$qvalue);
write.table(pval, out, sep = "\t", quote=F, row.names=F, col.names = F);
