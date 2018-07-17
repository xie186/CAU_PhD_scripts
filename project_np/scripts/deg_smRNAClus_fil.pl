#!/usr/bin/perl -w
use strict;
use Cwd;
my $working_dir = getcwd;

die usage() unless @ARGV == 3;
my ($pair, $cut_p, $cut_log2fc) = @ARGV;


open PAIR, $pair or die "$!";
while(<PAIR>){
    chomp;
    my ($ctrl, $treat) = split(/\t/, $_);
    open IN, "cmp_$ctrl\_$treat\_exp.fisherBH" or die "$!";
    open OUT, "+>cmp_$ctrl\_$treat\_exp.fisherBH.fil" or die "$!";
    my ($up, $down) = (0,0);
    while(my $line = <IN>){
        chomp $line;
        next if $line =~ /#/;
        my ($chr, $stt, $end, $ctrl, $mut, $rpkm_ctrl, $rpm_mut, $log2fc, $p_val, $corr_p_val) = split(/\t/, $line);
        #print "$chr, $stt, $end, $ctrl, $mut, $rpkm_ctrl, $rpm_mut, $log2fc, $p_val, $corr_p_val\n";
        if($corr_p_val < $cut_p && abs($log2fc) > $cut_log2fc){
            #print "$chr, $stt, $end, $ctrl, $mut, $rpkm_ctrl, $rpm_mut, $log2fc, $p_val, $corr_p_val\n";
            print OUT "$line\n";
            if($log2fc > 0){
                $up ++;
            }else{
                $down ++;
            }
        } 
    }
    print "$ctrl\t$treat\t$up\t$down\n";
    close OUT;
}

sub getTotalRead{
    my ($sam) = @_;
    open IN, "smRNA_$sam\_collap.stat" or die "$!:$sam\_collap.stat";
    my $tot = 0;
    while(<IN>){
        chomp;
        my ($len, $num) = split;
        $tot += $num;
    }
    return $tot;
}

sub usage{
    my $die = <<DIE;
perl $0 <input_cmp_pair> <cut pvalue> <cut log2fc> 
DIE
}
