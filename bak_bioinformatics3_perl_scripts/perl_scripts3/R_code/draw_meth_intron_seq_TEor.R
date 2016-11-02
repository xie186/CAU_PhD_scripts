draw_meth_intron_seq_TEor<-function(ara_file,rice_file,zm_file){
    ara<-read.table(ara_file)
    rice<-read.table(rice_file)
    zm <- read.table(zm_file)

    ara_nt <- ara[ara[,1] == "intron_NT",]
    ara_te <- ara[ara[,1] == "intron_TE",]
    boxplot(ara_nt[ara_nt[,2]=="CpG",][,6], ara_nt[ara_nt[,2]=="CHG",][,6], ara_nt[ara_nt[,2]=="CHH",][,6], ara_te[ara_te[,2]=="CpG",][,6], ara_te[ara_te[,2]=="CHG",][,6], ara_te[ara_te[,2]=="CHH",][,6], outline = TRUE, boxwex=.10 ,at=1:6-.5,col="red", xlim=c(0,6.5),axes=FALSE, pars = list(outcol = "red", outpch = "."))

    rice_nt <- rice[rice[,1] == "intron_NT",]
    rice_te <- rice[rice[,1] == "intron_TE",]
    boxplot(rice_nt[rice_nt[,2]=="CpG",][,6], rice_nt[rice_nt[,2]=="CHG",][,6], rice_nt[rice_nt[,2]=="CHH",][,6], rice_te[rice_te[,2]=="CpG",][,6], rice_te[rice_te[,2]=="CHG",][,6], rice_te[rice_te[,2]=="CHH",][,6], outline = TRUE, boxwex=.10 ,at=1:6 - 0.2 ,col="royalblue", xlim=c(0,6.5), add=T, pars = list(outcol = "royalblue", outpch = ".") , axes=FALSE) ## add = T

    zm_nt <- zm[zm[,1] == "intron_NT",]
    zm_te <- zm[zm[,1] == "intron_TE",]
    boxplot(zm_nt[zm_nt[,2]=="CpG",][,6], zm_nt[zm_nt[,2]=="CHG",][,6], zm_nt[zm_nt[,2]=="CHH",][,6], zm_te[zm_te[,2]=="CpG",][,6], zm_te[zm_te[,2]=="CHG",][,6], zm_te[zm_te[,2]=="CHH",][,6], outline = TRUE, boxwex=.10 ,at=1:6+.1,col="darkgreen", add=T, xpd=TRUE , xlim=c(0,6.5) , axes=FALSE, pars = list(outcol = "darkgreen"), outpch = ".") # add=T
     axis(1)
     axis(2)
     box()
}
