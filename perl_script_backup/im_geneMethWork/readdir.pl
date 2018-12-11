#!/usr/bin/perl -w
use strict;

opendir D,$ARGV[0] or die"$!";
my @filenm=readdir D;
#print "@filenm\n";
my @genm;
foreach(@filenm){
    my $ge=(split(/\.plot/,$_))[0] if /plot/;
    push @genm,$ge;
}
my $i=0;
my $j=0;
foreach(@genm){
    if(defined $_){
        #print "$_\n";
        system qq(grep "$_" ~/zhaohainan/mapanalyze/intergenic/ZmB73_4a.53_WGS.gff >/home/bioinformatics/xie/intronic/$_.stru);
        system qq(perl plot_xieIntronix_gene.pl /home/bioinformatics/xie/intronic/$_.plot /home/bioinformatics/xie/intronic/$_.stru >$_.svg);
    }    
}
#my $len=@genm;
#print "$i\t$j\n$len\n";
