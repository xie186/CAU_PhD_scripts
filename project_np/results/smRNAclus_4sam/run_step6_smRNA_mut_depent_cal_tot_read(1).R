BN1_37<-read.table("BN1_37_clean.stat");BN1_38<-read.table("BN1_38_clean.stat");col_rep1<-read.table("col_rep1.stat");col_rep2<-read.table("col_rep2.stat");wt_4rep<- rbind(BN1_37,BN1_38,col_rep1,col_rep2); sum(wt_4rep[wt_4rep[,1] >=18 & wt_4rep[,1]<=28,][,2])/4
#[1] 18083271



sam <- c("drm2_rep1.stat", "nrpd1_rep1.stat", "smRNA_1-20C3_collap.stat", "BN1_39_clean.stat", "BN1_40_clean.stat")
for(i in sam){
    stat <- read.table(i)
    tot <- sum(stat[stat[,1] >=18 & stat[,1]<=28,][,2])
    cat(i, tot, "\n")
}

drm2_rep1.stat 15618891
nrpd1_rep1.stat 14099947
smRNA_1-20C3_collap.stat 13636098
BN1_39_clean.stat 15151357
BN1_40_clean.stat 14344999


