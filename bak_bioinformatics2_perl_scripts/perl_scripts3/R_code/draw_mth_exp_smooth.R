draw_mth_exp_smooth<-function(mth_exp,tis){
    library(KernSmooth)
    cc<-read.table(mth_exp)
    grid<-length(cc[,1])
    bw<-dpill(cc[,2],cc[,1],gridsize=grid)
    lp<-locpoly(x=cc[,1],y=cc[,2],bandwidth=bw,gridsize=grid)
    plot(lp$x,lp$y,type="l",ylim=c(10,60),main=tis,xlab="Expression percentile",ylab="CG methylation")
}
