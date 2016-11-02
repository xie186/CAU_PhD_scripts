draw_3context<-function(cpg,chg,chh){
    par(mfrow=c(3,2),mar=c(2,4,1.5,1))
   
    ## CpG
    cc<-read.table(cpg)
    low<-cc[cc[,2]=="LOW",]
    low_exp<-low[low[,3]=="exp",]
    plot(low_exp[low_exp[,1]=="TE",][,6],type="l",ylim=c(0,max(cc[,6])),col="darkgreen",ylab="Methylation Level",axes=FALSE)
    lines(low_exp[low_exp[,1]=="NO",][,6],col="RoyalBlue")

    hi<-cc[cc[,2]=="HIGH",];hi_exp<-hi[hi[,3]=="exp",]
    lines(hi_exp[hi_exp[,1]=="TE",][,6],col="blue")
    lines(hi_exp[hi_exp[,1]=="NO",][,6],col="red")
    abline(v=20.5,lty="dashed",col="grey")
    abline(v=120.5,lty="dashed",col="grey")
    axis(2)
    axis(1,labels=FALSE,tick=FALSE)
    mtext(c("Gene body"),side=1,at=70,line=1)
    box()
    
    low<-cc[cc[,2]=="LOW",]
    low_exp<-low[low[,3]=="expno",]
    plot(low_exp[low_exp[,1]=="TE",][,6],type="l",ylim=c(0,max(cc[,6])),col="darkgreen",ylab="Methylation Level",axes=FALSE)
    lines(low_exp[low_exp[,1]=="NO",][,6],col="RoyalBlue");
    hi<-cc[cc[,2]=="HIGH",]
    hi_exp<-hi[hi[,3]=="expno",]
    lines(hi_exp[hi_exp[,1]=="TE",][,6],col="blue")
    lines(hi_exp[hi_exp[,1]=="NO",][,6],col="red")
    abline(v=20.5,lty="dashed",col="grey")
    abline(v=120.5,lty="dashed",col="grey")
    axis(2)
    axis(1,labels=FALSE,tick=FALSE)
    mtext(c("Gene body"),side=1,at=70,line=1)
    box()

    ## CHG
    cc<-read.table(chg)
    low<-cc[cc[,2]=="LOW",]
    low_exp<-low[low[,3]=="exp",]
    plot(low_exp[low_exp[,1]=="TE",][,6],type="l",ylim=c(0,max(cc[,6])),col="darkgreen",ylab="Methylation Level",axes=FALSE)
    lines(low_exp[low_exp[,1]=="NO",][,6],col="RoyalBlue")

    hi<-cc[cc[,2]=="HIGH",];hi_exp<-hi[hi[,3]=="exp",]
    lines(hi_exp[hi_exp[,1]=="TE",][,6],col="blue")
    lines(hi_exp[hi_exp[,1]=="NO",][,6],col="red")
    abline(v=20.5,lty="dashed",col="grey")
    abline(v=120.5,lty="dashed",col="grey")
    axis(2)
    axis(1,labels=FALSE,tick=FALSE)
    mtext(c("Gene body"),side=1,at=70,line=1)
    box()

    low<-cc[cc[,2]=="LOW",]
    low_exp<-low[low[,3]=="expno",]
    plot(low_exp[low_exp[,1]=="TE",][,6],type="l",ylim=c(0,max(cc[,6])),col="darkgreen",ylab="Methylation Level",axes=FALSE)
    lines(low_exp[low_exp[,1]=="NO",][,6],col="RoyalBlue");
    hi<-cc[cc[,2]=="HIGH",]
    hi_exp<-hi[hi[,3]=="expno",]
    lines(hi_exp[hi_exp[,1]=="TE",][,6],col="blue")
    lines(hi_exp[hi_exp[,1]=="NO",][,6],col="red")
    abline(v=20.5,lty="dashed",col="grey")
    abline(v=120.5,lty="dashed",col="grey")
    axis(2)
    axis(1,labels=FALSE,tick=FALSE)
    mtext(c("Gene body"),side=1,at=70,line=1)
    box() 
      
    ##CHH
    cc<-read.table(chh)
    low<-cc[cc[,2]=="LOW",]
    low_exp<-low[low[,3]=="exp",]
    plot(low_exp[low_exp[,1]=="TE",][,6],type="l",ylim=c(0,max(cc[,6])),col="darkgreen",ylab="Methylation Level",axes=FALSE)
    lines(low_exp[low_exp[,1]=="NO",][,6],col="RoyalBlue")

    hi<-cc[cc[,2]=="HIGH",];hi_exp<-hi[hi[,3]=="exp",]
    lines(hi_exp[hi_exp[,1]=="TE",][,6],col="blue")
    lines(hi_exp[hi_exp[,1]=="NO",][,6],col="red")
    abline(v=20.5,lty="dashed",col="grey")
    abline(v=120.5,lty="dashed",col="grey")
    axis(2)
    axis(1,labels=FALSE,tick=FALSE)
    mtext(c("Gene body"),side=1,at=70,line=1)
    box()   
 
    low<-cc[cc[,2]=="LOW",]
    low_exp<-low[low[,3]=="expno",]
    plot(low_exp[low_exp[,1]=="TE",][,6],type="l",ylim=c(0,max(cc[,6])),col="darkgreen",ylab="Methylation Level",axes=FALSE)
    lines(low_exp[low_exp[,1]=="NO",][,6],col="RoyalBlue");
    hi<-cc[cc[,2]=="HIGH",]
    hi_exp<-hi[hi[,3]=="expno",]
    lines(hi_exp[hi_exp[,1]=="TE",][,6],col="blue")
    lines(hi_exp[hi_exp[,1]=="NO",][,6],col="red")
    abline(v=20.5,lty="dashed",col="grey")
    abline(v=120.5,lty="dashed",col="grey")
    axis(2)
    axis(1,labels=FALSE,tick=FALSE)
    mtext(c("Gene body"),side=1,at=70,line=1)
    box()
    #axis(2)
    #box()
    #rect(20.5,-max(cc[,6]),120.5,0,col="lightblue",border=NA)
}
