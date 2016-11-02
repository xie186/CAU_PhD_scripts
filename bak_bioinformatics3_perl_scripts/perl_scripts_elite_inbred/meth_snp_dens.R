meth_snp_dens<-function(snp_dens,context){
    dens <- read.table(snp_dens)
    dens <- dens[order(dens[,2]),]

    dens_ls<-dens[dens[,2]<0,];
    dens_ls_dmp<-dens_ls[dens_ls[,1]=="DMP",];
    dens_gt<-dens[dens[,2]>0,];
    dens_gt_dmp<-dens_gt[dens_gt[,1]=="DMP",]
    
    plot(dens_ls_dmp[,2],dens_ls_dmp[,3], xlim=c(-50,50),ylim=c(0,max(dens[,3])),type="l",axes=FALSE,col=rgb(74,126,187,max=255),lwd=2,main=context,ylab="# of SNPs",xlab="");
    lines(dens_gt_dmp[,2]+2,dens_gt_dmp[,3],col=rgb(74,126,187,max=255),lwd=2);

    rect(-0.5,0,2.5,max(dens[,3]),col="grey");
    axis(2);axis(1,at=c(-50,-25,-1));
    axis(1,at=c(3,28,53),labels=F);
#    box()
    mtext(c("1","25","50"),at=c(3,28,53),side=1,line=1)
   
    dens_ls<-dens[dens[,2]<0,];
    dens_ls_dmp<-dens_ls[dens_ls[,1]=="ALL_RAND",];
    dens_gt<-dens[dens[,2]>0,];
    dens_gt_dmp<-dens_gt[dens_gt[,1]=="ALL_RAND",]
    lines(dens_ls_dmp[,2],dens_ls_dmp[,3],col = rgb(190,75,72,max=255),lwd=2);
    lines(dens_gt_dmp[,2]+2,dens_gt_dmp[,3],col = rgb(190,75,72,max=255),lwd=2);
    
}
