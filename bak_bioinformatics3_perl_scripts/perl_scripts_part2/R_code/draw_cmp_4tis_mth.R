draw_cmp_4tis_mth<-function(meth,contxt){
    win<-read.table(meth)
    y_lim <- range(0, density(win[,4]-win[,5])$y,density(win[,4]-win[,6])$y, density(win[,4]-win[,7])$y, density(win[,5]-win[,6])$y, density(win[,5]-win[,7])$y, density(win[,6]-win[,7])$y)

    plot(density(win[,4]-win[,5],adjust = 10),col = "blue", main=contxt, ylim = y_lim/1.5)
    lines(density(win[,4]-win[,6],adjust = 10),col="red");
    lines(density(win[,4]-win[,7],adjust = 10),col="firebrick");
    lines(density(win[,5]-win[,6],adjust = 10),col="DarkCyan");
    lines(density(win[,5]-win[,7],adjust = 10),col="royalblue");
    lines(density(win[,6]-win[,7],adjust = 10),col="Orange3");
    abline(v=0)
    legend("topright", c("BB-BM", "BB-MB", "BB-MM","BM-MB","BM-MM","MB-MM"), col = c("blue","red","firebrick","DarkCyan","royalblue", "Orange3"),lty = 1 , lwd = 3) 

}
