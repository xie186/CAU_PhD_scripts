#!/usr/bin/perl -w
use strict;
use Statistics::R; # Module Version: 0.33 

my $R = Statistics::R->new();
die usage() unless @ARGV ==3;
my ($dms_pair, $dir, $cut) = @ARGV;
sub usage{
    my $die =<<DIE;
perl $0 <dms pair> <dir> <cut>
DIE
}
my @context = ("CpG", "CHG", "CHH");
open PAIR, $dms_pair or die "$!";
while(<PAIR>){
    chomp;
    my ($tis1, $tis2, $tis3, $tis4) = split;
    my %all_dms;
    foreach my $context(@context){
        print "#Start $tis1, $tis2, $tis3, $tis4, $context!!\n";
        my $pair1 = "$dir/bed_$tis1\_$tis2\_OTOB_$context.fisherBH";
        my $pair2 = "$dir/bed_$tis3\_$tis4\_OTOB_$context.fisherBH";
        my ($stat_num1, $stat_num2, $stat_lap) = &intersect($pair1, $pair2);
        my $cmd = <<CMD;
pdf("DMS_lap_$tis1\_$tis2\_$tis3\_$tis4\_$context.pdf");
venn_col <- c(rgb(79,129,189, max = 255), rgb(192,80,77, max = 255));
library(VennDiagram);
draw.pairwise.venn($stat_num1, $stat_num2, $stat_lap, c("$tis1\_$tis2", "$tis3\_$tis4") ,fill = venn_col, cat.pos = c(180, 180));
dev.off();
CMD
        $R -> run("$cmd");
        print "$cmd\n";
        print "#Finished\n";
    }
}
$R -> stop();

sub intersect{
    my ($pair1, $pair2) = @_;
    my ($stat_num1, $stat_num2, $stat_lap) = (0,0,0);
    my %stat_lap;
    open PAIR1, $pair1 or die "$!";
    while(<PAIR1>){
       next if /stt/;chomp;
       my ($chr, $stt, $end, $c1,$t1,$c2, $t2, $lev1, $lev2, $diff, $p_val, $adj_pval) = split;
       if($adj_pval < $cut){
           $stat_num1 ++;
           $stat_lap{"$chr\t$stt"} ++;
       }
    }
    close PAIR1;

    open PAIR1, $pair2 or die "$!";
    while(<PAIR1>){
       next if /stt/;chomp;
       my ($chr, $stt, $end, $c1,$t1,$c2, $t2, $lev1, $lev2, $diff, $p_val, $adj_pval) = split;
       if($adj_pval < $cut){
           $stat_num2 ++;
           $stat_lap{"$chr\t$stt"} ++;
       }
    }
    close PAIR1;
    
    foreach(keys %stat_lap){
        $stat_lap ++ if $stat_lap{$_} == 2;
    }
    return ($stat_num1, $stat_num2, $stat_lap);
}
