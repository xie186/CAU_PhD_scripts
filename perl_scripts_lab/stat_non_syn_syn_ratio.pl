#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 5;
my ($file, $var_dir, $func_class_dir,$out_ratio, $out_rep) = @ARGV;

open OUT1, "+>$out_ratio" or die "$!";
open OUT2, "+>$out_rep" or die "$!";
open FILE, $file or die "$!";
while(<FILE>){
    next if /^#/;
    chomp;
    my ($control, $stress) = split;
    my $sim_anno = "$var_dir/VarScan_$stress\_$control.snp.Somatic.hc.fil.pass.eff.sim"; 
    my $tem_class = "$func_class_dir/VarScan_$stress\_$control.snp.fil.funcClass.txt";
    open FUNC, $tem_class or die "$!";
    my %func_class;
    while(my $line = <FUNC>){
        chomp $line;
        my ($chr, $pos, $class) = split(/\t/, $line);
        #chr1    9260067 Coding 
        $func_class{"$chr\t$pos"} ++ if $class eq "Coding";
    }
    close FUNC;

    open SIM, $sim_anno or die "$!";
    my %rec_anno;
    my %rec_anno_all;
    while( my $line = <SIM>){
        chomp $line;
        #chr1    5594704 .       G       C       100.0   upstream_gene_variant   MODIFIER
        my ($chr,$pos,$dot, $ref,$alt,$qual,$anno) = split(/\t/,$line);
        if($anno eq "synonymous_variant" || $anno eq "missense_variant" ||$anno eq "stop_gained" ||$anno eq "stop_lost" ){
            $rec_anno{"$chr\t$pos"} .= $anno;
        }
        $rec_anno_all{"$chr\t$pos"} .= $anno;
    }
    my ($non_syn, $syn) = (0, 0);
    foreach my $coor(keys %func_class){
        if(!exists $rec_anno{$coor}){
            print "$control\t$stress\t$coor\t$rec_anno_all{$coor}\n";
        }else{
            print OUT2 "$coor\t$rec_anno{$coor}\n";
            if($rec_anno{$coor} !~ /synonymous_variant/){
                $non_syn ++;
            }else{
                 $syn ++;
            }
        }
    }
    print OUT1 "$control\t$stress\t$non_syn\t$syn\n";
    
}
close OUT1;
close OUT2;
close FILE;

sub usage{
    my $die =<<DIE;
    perl *.pl <file> <variation dir> <func class dir> <OUT1 ratio> <OUT report> > <chk err>
DIE
}
