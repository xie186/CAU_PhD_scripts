#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==2;
my ($chisq,$imp) = @ARGV;

open IMP,$imp or die "$!";
my %hash_snp;
while(<IMP>){
    chomp;
#    chr10   112394509       GRMZM5G845175   G/A     0       30      18      0       9.49E-15        1.97E-09        pat     10DAP
    my ($chr, $pos, $gene, $geno, $bmb,$bmm,$mbb,$mbm,$p1,$p2,$stat,$dap) = split;
    $hash_snp{"$chr\t$pos"} = "$gene\t$geno";
}
open CHI,$chisq or die "$!";
while(<CHI>){
    chomp;
    my ($chr,$pos,$bmb,$bmm,$mbb,$mbm,$p1,$p2) = split;
    next if ($p1 >= 0.05 || $p2 >= 0.05);
    next if !exists $hash_snp{"$chr\t$pos"};
    my ($imp_2to1,$imp_5to1) = &judge($bmb,$bmm,$mbb,$mbm);
    next if ($imp_5to1 ne "pat" && $imp_5to1 ne "mat"); 
    print "$chr\t$pos\t$hash_snp{\"$chr\t$pos\"}\t$bmb\t$bmm\t$mbb\t$mbm\t$p1\t$p2\t$imp_5to1\t14DAP\n";
}

sub judge{
    my ($bm_b,$bm_m,$mb_b,$mb_m) = @_;
    my ($imp_2to1,$imp_5to1) = (0,0);
    if(($bm_b/($bm_b+$bm_m) > 2/3 && $mb_m/($mb_b+$mb_m)>2/3)){
        $imp_2to1 = "mat";
        if($bm_b/($bm_b+$bm_m) > 10/11 && $mb_m/($mb_b+$mb_m)>10/11){
            $imp_5to1 = "mat";
        }else{
            $imp_5to1 = "NA";
        }
    }elsif($bm_m/($bm_b+$bm_m) > 1/3 && $mb_b/($mb_b+$mb_m)>1/3){
        $imp_2to1 = "pat";
        if(($bm_m/($bm_b+$bm_m) > 5/7 && $mb_b/($mb_b+$mb_m)>5/7)){
            $imp_5to1 = "pat";
        }else{
            $imp_5to1 = "NA";
        }
    }else{
        $imp_2to1 = "NA";
    }
    return ($imp_2to1,$imp_5to1);
}

sub usage{
    my $die =<<DIE;
    perl *.pl <chisq> <imp>
DIE
}

