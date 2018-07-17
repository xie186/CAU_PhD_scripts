pval_computing <- function(tab, output) {
    t <- read.table(tab);
    cat("reading", tab, "Done\n")
    p.val <- rep(NA, times = nrow(t));
    ind_1 <- seq(1:nrow(t));
		
		
     #chr1    3101    3200    4       0       68      4       0       53
     #p.val[ind_1] <- lapply(ind_1, function(x) fisher.test(matrix(c(t[x, 5], t[x, 8], t[x, 6], t[x, 9]), nrow = 2))$p.val);

     #chr3    14307921        14307921        5       11      15      22      0.31  0.41       -0.09
     #chr       stt     end c_num t_num c_num   t_num
     p.val[ind_1] <- lapply(ind_1, function(x) fisher.test(matrix(c(t[x, 4], t[x, 6], t[x, 5], t[x, 7]), nrow = 2))$p.val);
     cat("P-value calculated Done!\n\n");

     t <- cbind(t, as.numeric(p.val));
     cat("P-value cbind Done!\n\n");

     p.val.adj <- p.adjust(as.numeric(p.val), "BH")
     cat("P-valuea adjusted calculated Done!\n\n");
     
     t <- cbind(t, p.val.adj)
     colnames(t) <- c("chr", "stt", "end", "#c1","#t1","#c2", "#t2", "#lev1", "#lev2", "#diff", "p.val", "adj.pval")
     cat("P-value adjusted cbind Done!\n\n");     
     write.table(t, output, sep = "\t", quote = F, row.names =F)
}

####################################################################################################

Args <- commandArgs()
		
cat("Useage: R --vanilla --slave --input alignment_profile_file --output methylation_profile_file  < DMR_fisher_BH_correction.R\n")
	
for (i in 1:length(Args)) {
    if (Args[i] == "--input") file_name = Args[i+1]
    if (Args[i] == "--output") out_file = Args[i+1]
}
pval_computing(file_name, out_file)	
