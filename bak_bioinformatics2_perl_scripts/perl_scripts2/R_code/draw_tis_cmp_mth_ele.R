draw_tis_cmp_mth_ele<-function(sd,em,en,contxt,CpG){
    
    sd<-read.table(sd)
    sd<-sd[order(sd[,3]),]
    sd_exp<-sd[sd[,1]=="exp",]
    sd_expno<-sd[sd[,1]=="expno",]
    
    em<-read.table(em)
    em<-em[order(em[,3]),]
    em_exp<-em[em[,1]=="exp",]
    em_expno<-em[em[,1]=="expno",]

    en<-read.table(en)
    en<-en[order(en[,3]),]
    en_exp<-en[en[,1]=="exp",]
    en_expno<-en[en[,1]=="expno",]
        
    rang<-range(0,sd[,4],en[,4],em[,4])
    
    plot(1:100,sd_exp[sd_exp[,2]=="upstream",][,4],type="l",ylim=rang,xlim=c(0,700),col="red",xlab=contxt,ylab="Methylation Level(%)",axes=FALSE)
    lines(101:200,sd_exp[sd_exp[,2]=="first_exon",][,4],col="red")
    lines(201:300,sd_exp[sd_exp[,2]=="first_intron",][,4],col="red")
    lines(301:400,sd_exp[sd_exp[,2]=="internal_exon",][,4],col="red")
    lines(401:500,sd_exp[sd_exp[,2]=="internal_intron",][,4],col="red")
    lines(501:600,sd_exp[sd_exp[,2]=="last_exon",][,4],col="red")
    lines(601:700,sd_exp[sd_exp[,2]=="downstream",][,4],col="red")

    lines(1:100,em_exp[em_exp[,2]=="upstream",][,4],col="blue")
    lines(101:200,em_exp[em_exp[,2]=="first_exon",][,4],col="blue")
    lines(201:300,em_exp[em_exp[,2]=="first_intron",][,4],col="blue")
    lines(301:400,em_exp[em_exp[,2]=="internal_exon",][,4],col="blue")
    lines(401:500,em_exp[em_exp[,2]=="internal_intron",][,4],col="blue")
    lines(501:600,em_exp[em_exp[,2]=="last_exon",][,4],col="blue")
    lines(601:700,em_exp[em_exp[,2]=="downstream",][,4],col="blue") 
    
    lines(1:100,en_exp[en_exp[,2]=="upstream",][,4],col="darkgreen")
    lines(101:200,en_exp[en_exp[,2]=="first_exon",][,4],col="darkgreen")
    lines(201:300,en_exp[en_exp[,2]=="first_intron",][,4],col="darkgreen")
    lines(301:400,en_exp[en_exp[,2]=="internal_exon",][,4],col="darkgreen")
    lines(401:500,en_exp[en_exp[,2]=="internal_intron",][,4],col="darkgreen")
    lines(501:600,en_exp[en_exp[,2]=="last_exon",][,4],col="darkgreen")
    lines(601:700,en_exp[en_exp[,2]=="downstream",][,4],col="darkgreen")
     
    mtext(c("US","FE","FI","IE","II","LE","DS"),at=c(50,150,250,350,450,550,650),side=1,line=1)
    axis(2)
    box()
    
    abline(v=100.5,lty="dashed")
    abline(v=200.5,lty="dashed")
    abline(v=300.5,lty="dashed")
    abline(v=400.5,lty="dashed")
    abline(v=500.5,lty="dashed")
    abline(v=600.5,lty="dashed")
    
    plot(1:100,sd_expno[sd_expno[,2]=="upstream",][,4],type="l",ylim=rang,xlim=c(0,700),col="red",xlab=contxt,ylab="Methylation Level(%)",axes=FALSE)
    lines(101:200,sd_expno[sd_expno[,2]=="first_exon",][,4],col="red")
    lines(201:300,sd_expno[sd_expno[,2]=="first_intron",][,4],col="red")
    lines(301:400,sd_expno[sd_expno[,2]=="internal_exon",][,4],col="red")
    lines(401:500,sd_expno[sd_expno[,2]=="internal_intron",][,4],col="red")
    lines(501:600,sd_expno[sd_expno[,2]=="last_exon",][,4],col="red")
    lines(601:700,sd_expno[sd_expno[,2]=="downstream",][,4],col="red")

    lines(1:100,em_expno[em_expno[,2]=="upstream",][,4],col="blue")
    lines(101:200,em_expno[em_expno[,2]=="first_exon",][,4],col="blue")
    lines(201:300,em_expno[em_expno[,2]=="first_intron",][,4],col="blue")
    lines(301:400,em_expno[em_expno[,2]=="internal_exon",][,4],col="blue")
    lines(401:500,em_expno[em_expno[,2]=="internal_intron",][,4],col="blue")
    lines(501:600,em_expno[em_expno[,2]=="last_exon",][,4],col="blue")
    lines(601:700,em_expno[em_expno[,2]=="downstream",][,4],col="blue")

    lines(1:100,en_expno[en_expno[,2]=="upstream",][,4],col="darkgreen")
    lines(101:200,en_expno[en_expno[,2]=="first_exon",][,4],col="darkgreen")
    lines(201:300,en_expno[en_expno[,2]=="first_intron",][,4],col="darkgreen")
    lines(301:400,en_expno[en_expno[,2]=="internal_exon",][,4],col="darkgreen")
    lines(401:500,en_expno[en_expno[,2]=="internal_intron",][,4],col="darkgreen")
    lines(501:600,en_expno[en_expno[,2]=="last_exon",][,4],col="darkgreen")
    lines(601:700,en_expno[en_expno[,2]=="downstream",][,4],col="darkgreen")
     
    axis(1,labels=FALSE)
    mtext(c("US","FE","FI","IE","II","LE","DS"),at=c(50,150,250,350,450,550,650),side=1,line=1)
    axis(2)
    box()

    abline(v=100.5,lty="dashed")
    abline(v=200.5,lty="dashed")
    abline(v=300.5,lty="dashed")
    abline(v=400.5,lty="dashed")
    abline(v=500.5,lty="dashed")
    abline(v=600.5,lty="dashed") 
} 
