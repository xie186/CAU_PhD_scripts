#10 colors
color <- c(rgb(79,129,189,max = 255), rgb(192,80,77,max = 255), rgb(155,187,89,max = 255), rgb(128,100,162,max=255), rgb(75,172,198,max=255), rgb(247,150,70,max=255), rgb(44,77,117,max=255), rgb(119, 44, 42, max = 255), rgb(95,117,48,max=255), rgb(77,59,98,max=255))
#7 colors
#color <- c(rgb(79,129,189,max = 255), rgb(192,80,77,max = 255), rgb(155,187,89,max = 255), rgb(128,100,162,max=255), rgb(75,172,198,max=255), rgb(247,150,70,max=255), rgb(44,77,117,max=255))

max_yaxis <- function(tab){
    # input file name
    tem_file <- strsplit(tab,",");
    input<-tem_file[[1]]
    fir_file <- read.table(input[1]) 
    max_y <-max(fir_file[,7]);
    for(i in 2:length(input)){
        file <-read.table(input[i])
        if(max(file[,7]) > max_y) max_y = max(file[,7])
    }
    return (max_y)
    
}
draw <- function(tab, sam_name, num , contxt) {
    max_y <- max_yaxis(tab)

    for(i in 1:num){
        output <- paste("mth_geno_100k_chr", i, "_", contxt, ".pdf", sep = "")
        pdf(output,width = 3.6,height = 4)
        
        # input file name
        tem_file <- strsplit(tab,",");
        input<-tem_file[[1]]
        
        # sample name
        sam <- strsplit(sam_name,",")
        tis <- sam[[1]]
        
        chr <- paste("chr",i, sep="")
        cat(chr,"\n")
        fir_file <- read.table(input[1])      
        maxi <- max((fir_file[fir_file[,1] == chr,][,3]-50000)/1000000) 
        plot((fir_file[fir_file[,1] == chr,][,3]-50000)/1000000 , fir_file[fir_file[,1] == chr,][,7],ylim=c(0, max_y),type="l",ylab="",xlab="Chromosome Coordinates(M)",axes=FALSE,col = color[1]); 
        for(j in 2:length(input)){
            file <-read.table(input[j])
            lines((file[file[,1] == chr,][,3]-50000)/1000000 , file[file[,1] == chr,][,7],col = color[j])
        }
        mtext(c("Methylation Level"),side=2,line=2)

        legend(maxi-10, max_y*0.9,tis, cex=0.3, col=color[1:length(input)], pch=".",lty=1, ,lwd=2, bty = "n");
        axis(2)
        axis(1)
        dev.off()
    }
}

####################################################################################################

Args <- commandArgs()

cat("Useage: R --vanilla --slave --meth_info [meth_acr_gene1,meth_acr_gene2] --tis_info [tis1,tis2] --num [# of Chromosome] --context [CpG,CHG,CHH] < draw_meth_acr_geno.R \n")

for (i in 1:length(Args)) {
    if (Args[i] == "--meth_info") file_name = Args[i+1]
    if (Args[i] == "--tis_info") tis_info = Args[i+1]
    if (Args[i] == "--num") chr_num = Args[i+1]
    if (Args[i] == "--context") context = Args[i+1]
}
draw(file_name, tis_info, chr_num ,context)

