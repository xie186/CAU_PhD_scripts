MAX = 100;
INITM = 1;
call_mc <- function(tab, dep_cut, fdr, output){
    cat(date(), "starting reading", tab, "\n");
    t <-read.table(tab,header=T);
    cat(date(), "Finished reading!!\n")
     
    dep_cut_low <- as.numeric(unlist(strsplit(dep_cut,":")))[1]
    dep_cut_high <- as.numeric(unlist(strsplit(dep_cut,":")))[2]
    cat(dep_cut_low, dep_cut_high, "\n");

    chloro_mc <- 0;
    chloro_dep <- 0;
    cat("Done\n")
   
    #err_rate
    t.chrC <- t[grepl("chrC", t[,1]),] 
    chloro_mc <- sum(t.chrC$number_of_C)
    chloro_dep <- sum(t.chrC$number_of_C) + sum(t.chrC$number_of_T)
    err_rate <- chloro_mc/chloro_dep;
    cat(date(), err_rate, chloro_mc, chloro_dep, "\n");
 
    t<-t[!(t$number_of_C + t$number_of_T > dep_cut_high | t$number_of_C + t$number_of_T < dep_cut_low), ] 
    t <- t[!grepl("chrC", t[,1]) & !grepl("chrM", t[,1]),]

    p.val <- rep(NA, time = nrow(t))
    ind1 <- seq(1:nrow(t))

    #chromosome      position        number_of_C     number_of_T
    p.val[ind1] <- lapply(ind1, function(x) binom.test(t[x, 3], t[x, 3] + t[x, 4], err_rate)$p.value);
    cat("Binomial test P-value calculated Done!\n\n");
    #t <- cbind(t, as.numeric(p.val))
    t$p.val <- as.numeric(p.val)
    library(qvalue)
    q.val <- qvalue(as.numeric(p.val))$qvalues
    #t <- cbind(t, as.numeric(q.val))
    t$q.val <- as.numeric(q.val);

    rm(p.val);
    rm(q.val);

    # interation1;
    print("Starting to process CHG context")
    print(paste("----Error rate =", err_rate))
    print(paste("----Binomial probability table with error:", err_rate))
    print("----Cutoff with a 0.01 FDR")
    tot.sites <- nrow(t) 
    tot.mc <- nrow(t[ t$q.val < INITM, ])
    perc.mc <- tot.mc/tot.sites;
    print(paste("Iteration 1: ", INITM, ", %mC:", perc.mc));
    INITM <- fdr*perc.mc/(1-perc.mc);
    
    for(j in 2:MAX){
        tot.mc<-0;
        tot.mc <- nrow(t[ t$q.val < INITM, ])
        tem.perc.mc <- tot.mc/tot.sites;
        print(paste("Iteration", j ,": ", INITM, ", %mC:", tem.perc.mc, perc.mc));
        INITM <- fdr*tem.perc.mc/(1-tem.perc.mc);
        if(tem.perc.mc - perc.mc ==0){
            print("----Update calls")
            INITM <- fdr*tem.perc.mc/(1-tem.perc.mc);
            print(paste("----Performing final methylation call update with M =", INITM))
            print(paste("----Total mC number:", tot.mc))
            print(paste("----Total C number:", tot.sites))
            break;
        }
        perc.mc = tem.perc.mc;
    } 
    t$meth <- (t$q.val < INITM)
    colnames(t) <- c("chr", "pos", "#c1","#t1", "p.val", "qvalue", "METH")
    cat("Q cbind Done!\n\n");
    write.table(t, output, sep = "\t", quote = F, row.names =F)
}


##########################################################################
Args<-commandArgs()

cat("R --vanilla --slave --input <in> --dep_cut <n1:n2> --fdr <0.01> --out <outfile> < call_mc.R\n");

for(i in 1:length(Args)){
    if(Args[i] == "--input") file_name = Args[i+1]
    if(Args[i] == "--dep_cut") dep_cut = Args[i+1]
    if(Args[i] == "--fdr") fdr = as.numeric(Args[i+1])
    if(Args[i] == "--out") out.name = Args[i+1]
}

system.time(call_mc(file_name, dep_cut, fdr, out.name))
