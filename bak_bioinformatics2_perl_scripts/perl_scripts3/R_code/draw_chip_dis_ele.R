draw_mth_dis_ele<-function(te,nt){
    te<-read.table(te)
    te<-te[order(te[,2]),]
    nt<-read.table(nt)
    nt<-nt[order(nt[,2]),]
    rang<-range(0,te[,3],nt[,3])
 
    plot(1:20,te[te[,1]=="upstream",][,3],type="l",ylim=rang,xlim=c(0,140),col="red",xlab="",ylab="",axes=FALSE)
    lines(21:40,te[te[,1]=="first_exon",][,3],col="red")
    lines(41:60,te[te[,1]=="first_intron",][,3],col="red")
    lines(61:80,te[te[,1]=="internal_exon",][,3],col="red")
    lines(81:100,te[te[,1]=="internal_intron",][,3],col="red")
    lines(101:120,te[te[,1]=="last_exon",][,3],col="red")
    lines(121:140,te[te[,1]=="downstream",][,3],col="red")
   
    lines(1:20,nt[nt[,1]=="upstream",][,3],col="royalblue")
    lines(21:40,nt[nt[,1]=="first_exon",][,3],col="royalblue")
    lines(41:60,nt[nt[,1]=="first_intron",][,3],col="royalblue")
    lines(61:80,nt[nt[,1]=="internal_exon",][,3],col="royalblue")
    lines(81:100,nt[nt[,1]=="internal_intron",][,3],col="royalblue")
    lines(101:120,nt[nt[,1]=="last_exon",][,3],col="royalblue")
    lines(121:140,nt[nt[,1]=="downstream",][,3],col="royalblue")
 
    axis(2)
    axis(1,label=FALSE)
    mtext(c("US","FE","FI","IE","II","LE","DS"),at=c(10,30,50,70,90,110,130),side=1,line=0.5)
    mtext(c("Average Depth(bp)"),side=2,line=2)
    box();

    abline(v=20,lty="dashed")
    abline(v=40,lty="dashed")
    abline(v=60,lty="dashed")
    abline(v=80,lty="dashed")
    abline(v=100,lty="dashed")
    abline(v=120,lty="dashed")
}
