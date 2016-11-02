pval_computing <- function(tab, output) {
    t <- read.table(tab);
    cat("reading", tab, "Done\n")
    p.val <- rep(NA, times = nrow(t));
    ind_1 <- seq(1:nrow(t));
		
		
     #chr1    3101    3200    4       0       68      4       0       53
     #chr	stt	end	#ofSites c_num	t_num	#ofSites	c_num	t_num
     p.val[ind_1] <- lapply(ind_1, function(x) fisher.test(matrix(c(t[x, 5], t[x, 8], t[x, 6], t[x, 9]), nrow = 2))$p.val);
     cat("P-value calculated Done!\n\n");

     p.val <- as.numeric(p.val)
     p.val[p.val > 1] <- 1
     t <- cbind(t, p.val);
     cat("P-value cbind Done!\n\n");

     library(qvalue)
     q.val <- qvalue(p.val)
     cat("Q-value calculated Done!\n\n");

     t <- cbind(t, q.val$qvalues)
     #colnames(t) <- c("chr", "stt", "end", "#cytosine1", "#c1","#t1","#cytosine2", "#c2", "#t2", "p.val", "q.val")
     cat("Q-value cbind Done!\n\n");     
     write.table(t, output, sep = "\t", quote = F, row.names =F, col.names=F)
}

####################################################################################################

Args <- commandArgs()
		
cat("Useage: R --vanilla --slave --input alignment_profile_file --output methylation_profile_file  < DMR_fisher_BH_correction.R\n")
	
for (i in 1:length(Args)) {
    if (Args[i] == "--input") file_name = Args[i+1]
    if (Args[i] == "--output") out_file = Args[i+1]
}
pval_computing(file_name, out_file)
