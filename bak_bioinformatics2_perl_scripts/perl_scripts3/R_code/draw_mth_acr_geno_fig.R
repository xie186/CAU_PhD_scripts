draw_mth_acr_geno<-function(spec,nu){
    tis<-c("sd","em","en")
    for(t in tis){
        for(i in 1:nu){
            out<-paste(spec,"_fig_mth_geno_100k_",t,"_chr",i,".pdf",sep="")
            pdf(out,width=7,height=3.5) 
#            par(mfrow=c(3,1),mar=c(2,3,3,1))
            cat("Hello\n")
            file<-paste(spec,"_fea_mth_geno_100k_",t,"_chr",i,"_CpG.res",sep="")
            cpg<-read.table(file)
            file<-paste(spec,"_fea_mth_geno_100k_",t,"_chr",i,"_CHG.res",sep="")
            chg<-read.table(file) 
            file<-paste(spec,"_fea_mth_geno_100k_",t,"_chr",i,"_CHH.res",sep="")
            chh<-read.table(file)
               
            rang<-range(0,cpg[,3],chg[,3],chh[,3])
            plot(cpg[,2]/1000000,cpg[,3],ylim=rang,type="l",ylab="",xlab="Chromosome Coordinates(M)",axes=FALSE,col="blue");
            lines(chg[,2]/1000000,chg[,4],col="red")
            lines(chh[,2]/1000000,chh[,4],col="darkgreen")
            mtext(c("Methylation Level(%)"),side=2,line=2)
            axis(2)
            axis(1)
            box()
            
            dev.off() 
         }

    }
}
