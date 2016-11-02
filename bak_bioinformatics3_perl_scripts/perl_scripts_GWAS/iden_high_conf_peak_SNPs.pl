#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 5;
my ($pheno, $pwd,$win,$cut1,$cut2) = @ARGV;
open PHENO,$pheno or die "$!";
while(my $tem_phe = <PHENO>){
    chomp $tem_phe;
    my $p_log = "$pwd/GAPIT.$tem_phe.photype.GWAS.ps.p2log";
    if(!-e "$pwd/GAPIT.$tem_phe.photype.GWAS.ps.p2log"){
        print "xx\t$p_log\n";
        next;
    }
    open LOG,$p_log or die "$!";
    my %peak_snp;
    my %p_snp;
    while(my $line = <LOG>){
        chomp $line;
        my ($chr,$pos,$maf,$log) = split(/\t/,$line);
        if($log >= $cut1){
            $peak_snp{"$chr\t$pos"} = $line;
            print "peak\t$line\n";
        }
        $p_snp{"$chr\t$pos"} = $line;
    }
   
    foreach my $coor (keys %peak_snp){
        my ($chr,$pos) = split(/\t/,$coor);
        my $number = 0;
        my $num_tot = 0;
        for(my $i = $pos - $win;$i <= $pos + $win; ++$i){
            if(exists $p_snp{"$chr\t$i"}){
                ++ $num_tot;
                my ($tem_chr,$tem_pos,$tem_maf,$tem_log) = split(/\t/,$p_snp{"$chr\t$i"});
                if($tem_log < $cut1 && $tem_log >= $cut2){
                    ++ $number;
                }
            }
        }
        print "$tem_phe\t$peak_snp{\"$coor\"}\t$num_tot\t$number\n";
    }
}

sub usage{
    my $die =<<DIE;
    perl *.pl <pheno> <pwd> <windows> <cut1> <cut2> 
DIE
}
