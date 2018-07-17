color <- c(rgb(79,129,189,max = 255), rgb(192,80,77,max = 255), rgb(155,187,89,max = 255), rgb(128,100,162,max=255), rgb(75,172,198,max=255), rgb(247,150,70,max=255), rgb(44,77,117,max=255))

draw_venn<-function(tab, sam, output){
    
    clus <- unlist(strsplit(tab, split=","))
    #4671289,1467559
    sam_list <- unlist(strsplit(sam, split=","))
    lst <- list()
    for(i in 1:length(clus)){
	cc<-read.table(clus[i], header=T)
	cc<-cc[cc$adj.pval < 0.00001,]
	cc<-paste(cc[,1], cc[,2], sep="_")
        lst[[sam_list[i]]] = cc 
    }
    print(lst)
    
     library("VennDiagram")
     venn.diagram(x = lst, filename = output, col = "transparent", fill = color[1:length(clus)])  
}

####################################################################################################

Args <- commandArgs()
		
cat("Useage: R --vanilla --slave --input fisher1,fisher2 --sam <sam1,sam2> --output pdf  < DMR_fisher_BH_correction.R\n")
	
for (i in 1:length(Args)) {
    if (Args[i] == "--input") file_name = Args[i+1]
    if (Args[i] == "--sam") sam = Args[i+1]
    if (Args[i] == "--output") out_file = Args[i+1]
}
draw_venn(file_name, sam, out_file)	
