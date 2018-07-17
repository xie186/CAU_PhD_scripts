#10 colors
color <- c(rgb(79,129,189,max = 255), rgb(192,80,77,max = 255), rgb(155,187,89,max = 255), rgb(128,100,162,max=255), rgb(75,172,198,max=255), rgb(247,150,70,max=255), rgb(44,77,117,max=255), rgb(119, 44, 42, max = 255), rgb(95,117,48,max=255), rgb(77,59,98,max=255))
#7 colors
#color <- c(rgb(79,129,189,max = 255), rgb(192,80,77,max = 255), rgb(155,187,89,max = 255), rgb(128,100,162,max=255), rgb(75,172,198,max=255), rgb(247,150,70,max=255), rgb(44,77,117,max=255))

draw <- function(tab, sam_name, output) {

    pdf(output,width = 3.6,height = 4)
    tem_file <- strsplit(tab,",");
    input<-tem_file[[1]]
    sam <- strsplit(sam_name,",")
    tis <-sam[[1]]
    fir <- read.table(input[1])
    max <- max(fir[,3])
    for(i in 2:length(input)){
        sec <- read.table(input[i])
        if (max < max(sec[,3])) max <- max(sec[,3]) 
    }
    plot(fir[,3]*100,type="l",ylim=c(0,max*100),col=color[1], axes = FALSE,lwd=1.5,xlab="",ylab="");
    for(i in 2:length(input)){
        sec <- read.table(input[i])
        lines(sec[,3]*100,col=color[i], lwd=1.5); 
    }

    axis(2)
    axis(1,labels=FALSE,at=c(0,20.5,80.5,100))
    mtext(c("-2k"),side=1,at = c(10),line=0.5)
    mtext(c("2k"),side=1,at = c(90),line=0.5)
    #mtext(context,side=1,line=0.5)
    mtext(c("Methylation Level(%)"),side=2,line=2)

    abline(v=20.5,lty="dashed");
    abline(v=80.5,lty="dashed");
    #legend(1,max*0.9*100, tis, cex=0.5, color[1:length(input)], lty=1:3, lwd=1, bty="n");
    legend(1,max*0.9*100, tis, col=color[1:length(input)], pch=".",lty=1, ,lwd=2, bty = "n", cex=0.4);
#    legend(maxi-10, max_y*0.9,tis, cex=0.8, col=color[1:length(input)], pch=".",lty=1, ,lwd=2)
    dev.off();
}

####################################################################################################

Args <- commandArgs()

cat("Useage: R --vanilla --slave --meth_info [meth_acr_gene1,meth_acr_gene2] --tis_infor [tis1,tis2] --output pdf < draw_meth_acr_gene.R \n")

for (i in 1:length(Args)) {
    if (Args[i] == "--meth_info") file_name = Args[i+1]
    if (Args[i] == "--tis_infor") tis_info = Args[i+1]
    if (Args[i] == "--output") out = Args[i+1]
}
draw(file_name, tis_info, out)

