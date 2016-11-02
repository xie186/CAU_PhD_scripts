#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 4;
my ($geno_len, $cutoff, $p_log, $pheno) = @ARGV;
open LEN,$geno_len or die "$!";
my %geno_len;
while(<LEN>){
    chomp;
    next if (/chr12/ || /chr11/ || /chr0/);
    $_ =~ s/chr//;
    my ($chr,$len) = split;
    $geno_len{$chr} = $len + 100000000;
}

my $tot_len = 0;
my @geno_stt;
my @geno_mid;
foreach my $chr (sort {$a<=>$b} keys  %geno_len){
    my $tem_len = $geno_len{$chr};
    my $tem_mid = $tot_len + $tem_len/2;
    push @geno_stt, $tot_len;
    push @geno_mid, $tem_mid;
    $tot_len += $tem_len;
}
my $geno_mid = join(",", @geno_mid);
my $geno_stt = join(",", @geno_stt);
open R, "+>$p_log.manhattan.R";
print R <<R_CODE;
tiff("$p_log.manhattan.tiff", compression=c("lzw"),height=300)
par(mar = c(5,5,3,1))
p_value <- read.table("$p_log");
p_max <- max(p_value[,4])
plot(p_value[p_value[,1]==1,][,2], p_value[p_value[,1]==1,][,4],pch=20,col=\"red\",xlim=c(0, $tot_len),ylim=c(0, p_max),xaxt=\"n\",xlab=expression(Chromosome),ylab=expression(-log[10](italic(p))),cex.lab=1.5,main=\"$pheno\")
mid <- c($geno_mid)
stt <- c($geno_stt)
mtext(side = 1,at = mid[1], "1");
for( i in 2:10){
    if(i %% 2 == 0){
        points(stt[i] + p_value[p_value[,1]==i,][,2], p_value[p_value[,1]==i,][,4], pch=20);
    }else{
        points(stt[i] + p_value[p_value[,1]==i,][,2], p_value[p_value[,1]==i,][,4], pch=20, col = "red");
    }
    mtext(side=1,at = mid[i], i)
}
abline(h = $cutoff,lty=2)
dev.off()
R_CODE
system "R --vanilla --slave <$p_log.manhattan.R";

sub usage{
    print <<DIE;
    perl *.pl <geno_len> <cutoff> <p_log> <pheno> 
DIE
    exit 1;
}
