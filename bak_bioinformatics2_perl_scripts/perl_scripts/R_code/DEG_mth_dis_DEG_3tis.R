DEG_mth_dis_DEG_3tis<-function(sd,em,endo,OUT){

    cg_sd<-read.table(sd)
    cg_en<-read.table(em)
    cg_em<-read.table(endo)
    pdf(OUT)
    maxi<-max(cg_sd[,3],cg_en[,3],cg_em[,3])
    plot(cg_sd[,3],type="l",col="red",ylim=c(0,maxi))
    lines(cg_en[,3],col="blue")
    lines(cg_em[,3],col="DarkGreen")
    

    abline(v=20.5,lty="dashed",col="grey")
    abline(v=120.5,lty="dashed",col="grey")
    dev.off()
}

