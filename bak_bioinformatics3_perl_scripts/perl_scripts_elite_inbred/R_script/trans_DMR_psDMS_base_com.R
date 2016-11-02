base_composition <- function(base_com, PDF){
   pdf(PDF,width = 5, height = 5);
#   pdf(PDF)
   cc<-read.table(base_com)
   stat<-cc[cc[,1]=="pDMS",];

   ylim_min <- min(cc[,3]/cc[,5],cc[,4]/cc[,5]);
   ylim_max <- max(cc[,3]/cc[,5],cc[,4]/cc[,5]);
   
   plot(1,type="n",xlim=c(-20,19),ylim=c(ylim_min, ylim_max), xlab="Distance from DMS clusters (kb)", ylab = "Nucleotide frequency",axes = F);
   axis(2);
   axis(1,label=F)
   box()
   mtext(c("-2", "-1", "0", "1", "2"),side = 1, line = 1, at = c(-20,-10,0,10,20)); 
   lines(stat[,2],stat[,3]/stat[,5],col = rgb(74,126,187,max=255), lwd = 2);
   lines(stat[,2],stat[,4]/stat[,5],col = rgb(74,126,187,max=255), lwd = 2, lty = "dashed");
   stat<-cc[cc[,1]=="sDMS",];
   lines(stat[,2],stat[,3]/stat[,5],col = rgb(190,75,72,max=255));
   lines(stat[,2],stat[,4]/stat[,5],col = rgb(190,75,72,max=255), lwd = 2, lty = "dashed");
   stat<-cc[cc[,1]=="Random",];
   lines(stat[,2],stat[,3]/stat[,5],col="gray", lwd = 2);
   lines(stat[,2],stat[,4]/stat[,5],col="gray", lwd = 2, lty = "dashed");
   
   legend(2.5,0.26,c("Cytosine (pDMS cluster)","Guanine (pDMS cluster)", "Cytosine (sDMS cluster)","Guanine (sDMS cluster)", "Cytosine (random)","Guanine (random)"),cex=0.8,col=c(rgb(74,126,187,max=255),rgb(74,126,187,max=255),rgb(190,75,72,max=255),rgb(190,75,72,max=255), "gray", "gray"), lty = c(1,2,1,2,1,2), lwd = 2); 
   dev.off()
}


Args <- commandArgs();
cat("Useage: R --vanilla --slave --input <input> --output <pdf> < trans_DMR_DMS_base_com.R", "\n");

cat (Args,"\n")
for (i in 1:length(Args)) {
        if (Args[i] == "--input")  base_com = Args[i+1]
        if (Args[i] == "--output") output = Args[i+1]
}

base_composition(base_com, output)
