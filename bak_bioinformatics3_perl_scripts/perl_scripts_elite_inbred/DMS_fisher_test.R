############ pDMS_fisher #################
pDMS_fisher <- function(alle.infor,output){
    cat(alle.infor,output,"\n\n")
    alle  <- file(alle.infor, open = "r")
    if(file.exists(output)){
        print ("The output file was exists!");
        file.remove(output)
        #q("yes")
    }
    print (paste("reading file",alle.infor))
    #    res   <- file(output, open = "w")
    while (length(oneLine <- readLines(alle, n = 1)) > 0) {
        myLine <- unlist((strsplit(oneLine, "\t")))
        if(myLine[2] == "POS"){
            next
        }
        #print (oneLine)
        tab <- c(as.numeric(myLine[4]),as.numeric(myLine[6]),as.numeric(myLine[5]),as.numeric(myLine[7]))
        
        dim(tab)<-c(2,2)
        pvalue1 <- fisher.test(tab)$p.value
        if(pvalue1 > 1){
            pvalue1 = 1
        }
        #tab <- c(as.numeric(myLine[7]),as.numeric(myLine[9]),as.numeric(myLine[8]),as.numeric(myLine[10]))
        #dim(tab)<-c(2,2)
        #pvalue2 <- fisher.test(tab)$p.value
        #if(pvalue2 > 1){
            #pvalue2 = 1
        #}
        out <- c(myLine,pvalue1,"\n")
#        out1 <- (paste(out,sep = ""))
#        writeLines(out1, con = res, sep = "")
        cat(out,file=output,append=TRUE,sep = "\t")
    }
    close(alle)
    print ("Done")
}
############ pDMS_fisher #################

Args <- commandArgs()
cat("Useage: R --vanilla --slave --input <input> --output <output> < pDMS_fisher_test.R", "\n")
cat (Args,"\n")
for (i in 1:length(Args)) {
	if (Args[i] == "--input")  alle.infor = Args[i+1]
	if (Args[i] == "--output") output = Args[i+1]
}
	
cc<-pDMS_fisher(alle.infor,output)
