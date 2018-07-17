#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 5;
my ($file, $var_dir, $sift_res, $out_ratio, $out_rep) = @ARGV;

open SIFT, $sift_res or die "$!";
my %rec_sift;
while(<SIFT>){
    chomp;
    my ($chr, $geno_pos, $dot1, $ref, $alt, $amino_chg, $aa1, $pos, $aa2, $id, $class, $score) = split;
    $rec_sift{"$chr\t$geno_pos"} .= $class;
}


open OUT1, "+>$out_ratio" or die "$!";
open OUT2, "+>$out_rep" or die "$!";
open FILE, $file or die "$!";
while(<FILE>){
    next if /^#/;
    chomp;
    my ($control, $stress, $tis) = split;
    my $sim_anno = "$var_dir/VarScan_$stress\_$control.snp.Somatic.hc.fil.pass.eff.sim"; 
    open SIM, $sim_anno or die "$!";
    my %rec_anno;
    my %rec_anno_all;
    while( my $line = <SIM>){
        chomp $line;
        #chr1    5594704 .       G       C       100.0   upstream_gene_variant LOW AT1G04770       AT1G04770.1     nrpe1a-0uMs
        my ($chr,$pos,$dot, $ref,$alt,$qual,$anno, $eff, $id, $trans) = split(/\t/,$line);
        next if $line =~ /AT3G41762/;
        if($anno eq "missense_variant" ||$anno eq "stop_gained" ||$anno eq "stop_lost" ){
            $rec_anno{"$chr\t$pos"} .= $anno;
        }
    }
    my ($dele, $tor) = (0, 0);
    foreach my $coor(keys %rec_anno){
        if($rec_anno{$coor} =~ /stop/){
            $dele ++;
            print OUT2 "$coor\tDELETERIOUS_STOP\n";
        }else{
            print "$_\t$coor\n" if !exists $rec_sift{$coor};
            if($rec_sift{$coor} =~ /DELETERIOUS/){
                $dele ++;
            }else{
                $tor ++;
            }
            print OUT2 "$coor\t$rec_sift{$coor}\n";
        }
    }
    print OUT1 "$control\t$stress\t$tis\t$dele\t$tor\n";
    
}
close OUT1;
close OUT2;
close FILE;

sub usage{
    my $die =<<DIE;
    perl *.pl <file> <variation dir> <func class dir> <OUT1 ratio> <OUT report> > <chk err>
DIE
}
