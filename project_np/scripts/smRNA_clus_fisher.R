pval_computing <- function(tab, output, tot_read) {
    t <- read.table(tab);
    cat("reading", tab, "Done\n")
    p.val <- rep(NA, times = nrow(t));
    ind_1 <- seq(1:nrow(t))
    
     #4671289,1467559
    tot <- as.numeric(unlist(strsplit(tot_read, split=",")))		
    tot_wt <- tot[1]  
    tot_mut <- tot[2]
     #chr1    3101    3200    4558 34
     p.val[ind_1] <- lapply(ind_1, function(x) fisher.test(matrix(c(t[x, 5], t[x, 4], tot_mut - t[x, 5] , tot_wt - t[x, 4]), nrow = 2), alternative ="l")$p.val);
     #p.val[ind_1] <- lapply(ind_1, function(x) fisher.test(matrix(c(t[x, 5], t[x, 4], tot_mut - t[x, 5] , tot_wt - t[x, 4]), nrow = 2))$p.val);
     cat("P-value calculated Done!\n\n");
 
     rpm.ctrl <- rep(NA, times = nrow(t));
     rpm.ctrl[ind_1] <- lapply(ind_1, function(x)  t[x, 4]*1000000/tot_wt);

     rpm.mut <- rep(NA, times = nrow(t));
     rpm.mut[ind_1] <- lapply(ind_1, function(x) t[x, 5]*1000000/tot_mut);
     
     log2fc <- rep(NA, times = nrow(t));
     log2fc[ind_1] <- lapply(ind_1, function(x)  log2(as.numeric(rpm.mut[x])/as.numeric(rpm.ctrl[x])));

     t <- cbind(t, as.numeric(rpm.ctrl));
     t <- cbind(t, as.numeric(rpm.mut));
     t <- cbind(t, as.numeric(log2fc));
     t <- cbind(t, as.numeric(p.val));
     cat("P-value cbind Done!\n\n");

     p.val.adj <- p.adjust(as.numeric(p.val), "BH")
     cat("P-valuea adjusted calculated Done!\n\n");
     
     t <- cbind(t, p.val.adj)
     colnames(t) <- c("chr", "stt", "end", "rpm.ctrl","rpm.mut","log2fc", "#num1","#num2", "p.val", "adj.pval")
     cat("P-value adjusted cbind Done!\n\n");     
     write.table(t, output, sep = "\t", quote = F, row.names =F)
}

####################################################################################################

Args <- commandArgs()
		
cat("Useage: R --vanilla --slave --input smRNA_wt_mut --tot --output smRNA_wt_mutFisherTest  < DMR_fisher_BH_correction.R\n")
	
for (i in 1:length(Args)) {
    if (Args[i] == "--input") file_name = Args[i+1]
    if (Args[i] == "--tot") tot_read = Args[i+1]
    if (Args[i] == "--output") out_file = Args[i+1]
}
pval_computing(file_name, out_file, tot_read)	
