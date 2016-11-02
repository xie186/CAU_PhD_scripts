draw_TE_mth_against_len<-function(mth){
    cc<-read.table(mth)
    plot(cc[,3]-cc[,2]+1,cc[,8],xlim=c(0,5000),pch=".",xlab="Length of TEs",ylab="Methylation Level(%)")
}
