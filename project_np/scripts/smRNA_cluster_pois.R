pval_computing <- function(tab, output) {
    t <- read.table(tab);
    cat("reading", tab, "Done\n")
    p.val <- rep(NA, times = nrow(t));
    ind_1 <- seq(1:nrow(t))

    lambda <- sum(t[, 4])/nrow(t)
    #1       800     1000    12613		59
    p.val[ind_1] <- lapply(ind_1, function(x) 1-ppois(t[x, 4], lambda = lambda));
     cat("P-value calculated Done!\n\n");

     t <- cbind(t, as.numeric(p.val));
     cat("P-value cbind Done!\n\n");

     write.table(t, output, sep = "\t", quote = F, row.names =F,col.names=F)
}

####################################################################################################

Args <- commandArgs()
		
cat("Useage: R --vanilla --slave --input poisson_res_input --output poisson_res  < test.R\n")

	
for (i in 1:length(Args)) {
    if (Args[i] == "--input") file_name = Args[i+1]
    if (Args[i] == "--output") out_file = Args[i+1]
}
pval_computing(file_name, out_file)	
