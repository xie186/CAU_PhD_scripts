meth_dis_dif_ele_3par<-function(low_te,low_no,hi_te,hi_no,contxt){
    
    low_te<-read.table(low_te)
    low_te<-low_te[order(low_te[,3]),]
    low_te_exp<-low_te[low_te[,1]=="exp",]
    low_te_expno<-low_te[low_te[,1]=="expno",]
    
    low_no<-read.table(low_no)
    low_no<-low_no[order(low_no[,3]),]
    low_no_exp<-low_no[low_no[,1]=="exp",]
    low_no_expno<-low_no[low_no[,1]=="expno",]

    hi_te<-read.table(hi_te)
    hi_te<-hi_te[order(hi_te[,3]),]
    hi_te_exp<-hi_te[hi_te[,1]=="exp",]
    hi_te_expno<-hi_te[hi_te[,1]=="expno",]

    hi_no<-read.table(hi_no)
    hi_no<-hi_no[order(hi_no[,3]),]
    hi_no_exp<-hi_no[hi_no[,1]=="exp",]
    hi_no_expno<-hi_no[hi_no[,1]=="expno",]
    rang<-range(0,low_te[,4],low_no[,4],hi_te[,4],hi_no[,4])
    
    plot(1:100,low_te_exp[low_te_exp[,2]=="upstream",][,4],type="l",ylim=rang,xlim=c(0,700),col="darkgreen",xlab=contxt,ylab="Methylation Level(%)",axes=FALSE)
    lines(101:200,low_te_exp[low_te_exp[,2]=="first_exon",][,4],col="darkgreen")
    lines(201:300,low_te_exp[low_te_exp[,2]=="first_intron",][,4],col="darkgreen")
    lines(301:400,low_te_exp[low_te_exp[,2]=="internal_exon",][,4],col="darkgreen")
    lines(401:500,low_te_exp[low_te_exp[,2]=="internal_intron",][,4],col="darkgreen")
    lines(501:600,low_te_exp[low_te_exp[,2]=="last_exon",][,4],col="darkgreen")
    lines(601:700,low_te_exp[low_te_exp[,2]=="downstream",][,4],col="darkgreen")

    lines(1:100,low_no_exp[low_no_exp[,2]=="upstream",][,4],col="royalblue")
    lines(101:200,low_no_exp[low_no_exp[,2]=="first_exon",][,4],col="royalblue")
    lines(201:300,low_no_exp[low_no_exp[,2]=="first_intron",][,4],col="royalblue")
    lines(301:400,low_no_exp[low_no_exp[,2]=="internal_exon",][,4],col="royalblue")
    lines(401:500,low_no_exp[low_no_exp[,2]=="internal_intron",][,4],col="royalblue")
    lines(501:600,low_no_exp[low_no_exp[,2]=="last_exon",][,4],col="royalblue")
    lines(601:700,low_no_exp[low_no_exp[,2]=="downstream",][,4],col="royalblue") 
    
    lines(1:100,hi_te_exp[hi_te_exp[,2]=="upstream",][,4],col="blue")
    lines(101:200,hi_te_exp[hi_te_exp[,2]=="first_exon",][,4],col="blue")
    lines(201:300,hi_te_exp[hi_te_exp[,2]=="first_intron",][,4],col="blue")
    lines(301:400,hi_te_exp[hi_te_exp[,2]=="internal_exon",][,4],col="blue")
    lines(401:500,hi_te_exp[hi_te_exp[,2]=="internal_intron",][,4],col="blue")
    lines(501:600,hi_te_exp[hi_te_exp[,2]=="last_exon",][,4],col="blue")
    lines(601:700,hi_te_exp[hi_te_exp[,2]=="downstream",][,4],col="blue")
     
    lines(1:100,hi_no_exp[hi_no_exp[,2]=="upstream",][,4],col="red")
    lines(101:200,hi_no_exp[hi_no_exp[,2]=="first_exon",][,4],col="red")
    lines(201:300,hi_no_exp[hi_no_exp[,2]=="first_intron",][,4],col="red")
    lines(301:400,hi_no_exp[hi_no_exp[,2]=="internal_exon",][,4],col="red")
    lines(401:500,hi_no_exp[hi_no_exp[,2]=="internal_intron",][,4],col="red")
    lines(501:600,hi_no_exp[hi_no_exp[,2]=="last_exon",][,4],col="red")
    lines(601:700,hi_no_exp[hi_no_exp[,2]=="downstream",][,4],col="red")
    
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
    
    plot(1:100,low_te_expno[low_te_expno[,2]=="upstream",][,4],type="l",ylim=rang,xlim=c(0,700),col="darkgreen",xlab=contxt,ylab="Methylation Level(%)",axes=FALSE)
    lines(101:200,low_te_expno[low_te_expno[,2]=="first_exon",][,4],col="darkgreen")
    lines(201:300,low_te_expno[low_te_expno[,2]=="first_intron",][,4],col="darkgreen")
    lines(301:400,low_te_expno[low_te_expno[,2]=="internal_exon",][,4],col="darkgreen")
    lines(401:500,low_te_expno[low_te_expno[,2]=="internal_intron",][,4],col="darkgreen")
    lines(501:600,low_te_expno[low_te_expno[,2]=="last_exon",][,4],col="darkgreen")
    lines(601:700,low_te_expno[low_te_expno[,2]=="downstream",][,4],col="darkgreen")

    lines(1:100,low_no_expno[low_no_expno[,2]=="upstream",][,4],col="royalblue")
    lines(101:200,low_no_expno[low_no_expno[,2]=="first_exon",][,4],col="royalblue")
    lines(201:300,low_no_expno[low_no_expno[,2]=="first_intron",][,4],col="royalblue")
    lines(301:400,low_no_expno[low_no_expno[,2]=="internal_exon",][,4],col="royalblue")
    lines(401:500,low_no_expno[low_no_expno[,2]=="internal_intron",][,4],col="royalblue")
    lines(501:600,low_no_expno[low_no_expno[,2]=="last_exon",][,4],col="royalblue")
    lines(601:700,low_no_expno[low_no_expno[,2]=="downstream",][,4],col="royalblue")

    lines(1:100,hi_te_expno[hi_te_expno[,2]=="upstream",][,4],col="blue")
    lines(101:200,hi_te_expno[hi_te_expno[,2]=="first_exon",][,4],col="blue")
    lines(201:300,hi_te_expno[hi_te_expno[,2]=="first_intron",][,4],col="blue")
    lines(301:400,hi_te_expno[hi_te_expno[,2]=="internal_exon",][,4],col="blue")
    lines(401:500,hi_te_expno[hi_te_expno[,2]=="internal_intron",][,4],col="blue")
    lines(501:600,hi_te_expno[hi_te_expno[,2]=="last_exon",][,4],col="blue")
    lines(601:700,hi_te_expno[hi_te_expno[,2]=="downstream",][,4],col="blue")

    lines(1:100,hi_no_expno[hi_no_expno[,2]=="upstream",][,4],col="red")
    lines(101:200,hi_no_expno[hi_no_expno[,2]=="first_exon",][,4],col="red")
    lines(201:300,hi_no_expno[hi_no_expno[,2]=="first_intron",][,4],col="red")
    lines(301:400,hi_no_expno[hi_no_expno[,2]=="internal_exon",][,4],col="red")
    lines(401:500,hi_no_expno[hi_no_expno[,2]=="internal_intron",][,4],col="red")
    lines(501:600,hi_no_expno[hi_no_expno[,2]=="last_exon",][,4],col="red")
    lines(601:700,hi_no_expno[hi_no_expno[,2]=="downstream",][,4],col="red")

    abline(v=100.5,lty="dashed")
    abline(v=200.5,lty="dashed")
    abline(v=300.5,lty="dashed")
    abline(v=400.5,lty="dashed")
    abline(v=500.5,lty="dashed")
    abline(v=600.5,lty="dashed")
    axis(1,labels=FALSE)
    mtext(c("US","FE","FI","IE","II","LE","DS"),at=c(50,150,250,350,450,550,650),side=1,line=1)
    axis(2)
    box()
} 
