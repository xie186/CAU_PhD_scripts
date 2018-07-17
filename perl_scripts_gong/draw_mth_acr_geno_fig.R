draw_mth_acr_geno<-function(sam1,sam2,sam3,sam4,nu,contxt){

        sam1 <-read.table(sam1)
        sam2 <-read.table(sam2)
        sam3 <-read.table(sam3)
        sam4 <-read.table(sam4)  
        for(i in 1:nu){
            out<-paste("fig_mth_geno_100k_chr",i,"_", contxt ,".pdf",sep="")
            pdf(out,width=7,height=3.5) 
#            par(mfrow=c(3,1),mar=c(2,3,3,1))
            cat("Hello\n")
            chr <- paste("chr",i, sep="")
            cat(chr,"\n")
            rang <- range(0,sam1[,7],sam2[,7],sam3[,7],sam4[,7])
            maxi <- max((sam2[sam2[,1] == chr,][,3]-50000)/1000000)
            maxi_y <- max(sam1[,7],sam2[,7],sam3[,7],sam4[,7])
            cat(maxi,"\n")
            plot((sam1[sam1[,1] == chr,][,3]-50000)/1000000 , sam1[sam1[,1] == chr,][,7],ylim=rang,type="l",ylab="",xlab="Chromosome Coordinates(M)",axes=FALSE,col="blue");
            lines((sam2[sam2[,1] == chr,][,3]-50000)/1000000 , sam2[sam2[,1] == chr,][,7],col="red")
            lines((sam3[sam3[,1] == chr,][,3]-50000)/1000000 , sam3[sam3[,1] == chr,][,7],col="darkgreen")
            lines((sam4[sam4[,1] == chr,][,3]-50000)/1000000 , sam4[sam4[,1] == chr,][,7],col="gray")
            mtext(c("Methylation Level(%)"),side=2,line=2)
            legend(maxi -6,maxi_y*0.9,c("156","204","nrpd1a","c24"),cex=0.8,col=c("blue","red","darkgreen","gray"),lty=1); 
            axis(2)
            axis(1)
            box()
            
            dev.off() 
         }
}
