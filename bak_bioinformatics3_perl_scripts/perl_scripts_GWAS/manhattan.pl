#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==1;
my ($p_log) = @ARGV;
if(!-e "tem_dir_manhattan_plot"){
    system("mkdir tem_dir_manhattan_plot");
}
my ($tools,$pheno) = split(/\./,$p_log);
my %max;

for(my $i=1;$i<=10;$i++){
    $max{$i}=0;
}

open T, $p_log or die "$!";
my $n=1;
my $p_max=0;
#`rm -rf tem_dir_manhattan_plot/*` if -e "./tem_dir_manhattan_plot/*";
while (<T>){
    my ($chr,$pos,$maf,$log)=split(/\s+/,$_);
#    `rm tem_dir_manhattan_plot/temp-$p_log-chr$chr` if -e "./tem_dir_manhattan_plot/temp-$p_log-chr$chr";
    open T1, "+>>tem_dir_manhattan_plot/temp-$p_log-chr$chr";
    print T1 "$n\t$log\n";
    close T1;
    if($max{$chr} < $n){
        $max{$chr} = $n;
    }
    if($p_max < $log){
        $p_max = $log;
    }
    $n++;
}

$p_max ++;
$p_max = 7 if $p_max<7;

open R, "+>$p_log.manhattan.R";
print R "tiff(\"$p_log.manhattan.tiff\", compression=c(\"lzw\"),height=300)\n";
print R "par(mar = c(5,5,3,1))\n";
for(my $i=1;$i<=10;$i++){  ###read all the p value
    print R "chr$i<-read.table (\"tem_dir_manhattan_plot/temp-$p_log-chr$i\")\n";}
    print R "plot(chr1,pch=20,col=\"red\",xlim=c(0,$n),ylim=c(0,$p_max),xaxt=\"n\",xlab=expression(Chromosome),ylab=expression(-log[10](italic(p))),cex.lab=1.5,main=\"$pheno\")\n";
    my $mid=int($max{1}/2);
    print R "mtext(side=1,at=$mid,\"1\")\n";

for(my $i=2;$i<=10;$i++){
    if($i%2==0){
        print R "points(chr$i,pch=20)\n";
    }else{
        print R "points(chr$i,pch=20,col=\"red\")\n";
    }

    my $mid=int($max{$i-1}+($max{$i}-$max{$i-1})/2);
    print R "mtext(side=1,at=$mid,\"$i\")\n";
}
print R "abline(h=6.5,lty=2)\n";
print R "dev.off()\n";
system "R --vanilla --slave <$p_log.manhattan.R";
#system "rm temp-*-chr*";

sub usage{
    print <<DIE;
    perl *.pl <p value> 
DIE
    exit 1;
}
