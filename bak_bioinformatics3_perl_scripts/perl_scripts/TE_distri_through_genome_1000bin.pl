#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==3;
my ($geno_len,$gff,$out)=@ARGV;
#die "$out exists!!!\n" if -e $out;

open GENO,$geno_len or die "$!";
my %geno_len;
while(<GENO>){
    chomp;
    my ($chr,$len)=split;
    $geno_len{$chr}=$len;
}

## TE file
open TE,$gff or die "$!";
my %hash_gt1;my %hash_ls1;
my %hash_gt1_nu;my %hash_ls1_nu;
while(<TE>){
    next if /^#/;
    chomp;
    my ($chr,$stt,$end)=(split(/\s+/,$_));
    $chr = "chr".$chr;
    my $pos=int (($stt+$end)/2);
    if($end-$stt+1 > 1000){
        $hash_gt1{"$chr\t$pos"}++;
        $hash_gt1_nu{$chr}++;
    }else{
        $hash_ls1{"$chr\t$pos"}++;
        $hash_ls1_nu{$chr}++;
    }
}
open OUT,"+>$out" or die "$!";
for(my $chr_no=1;$chr_no<=keys %geno_len;++$chr_no){
    my $tem_chr="chr".$chr_no;
    my $aver_bin=$geno_len{$tem_chr}/1000;
    my @chr_TE_gt1;
    my @chr_TE_ls1;
    for(my $j=1;$j<=1000;++$j){
        for(my $h = int $aver_bin*($j-1);$h <= $aver_bin*$j;++$h){
#            print "$tem_chr\t$h\n";
            if(exists $hash_gt1{"$tem_chr\t$h"}){
               ++ $chr_TE_gt1[$j-1];
            }
            if(exists $hash_ls1{"$tem_chr\t$h"}){
               ++ $chr_TE_ls1[$j-1];
            }
        }
    }

    ### +-5 windows average 
    for(my $i=1;$i<=1000;++$i){
             my ($te_nu_gt1,$bin_nu_gt1,$te_nu_ls1,$bin_nu_ls1)=(0,0,0,0);
             for(my $h=-5;$h<=5;++$h){
                 my $pos = $i + $h;
                 next if($pos-1<0 || $pos -1 > 1000);
                 $te_nu_gt1 += $chr_TE_gt1[$pos];
                 ++ $bin_nu_gt1;
                 $te_nu_ls1 += $chr_TE_ls1[$pos];
                 ++ $bin_nu_ls1;
             }
             my $aver_nu_gt1 = $te_nu_gt1/$bin_nu_gt1/$hash_gt1_nu{$tem_chr};
             my $aver_nu_ls1 = $te_nu_ls1/$bin_nu_ls1/$hash_ls1_nu{$tem_chr};
             print "$i\t$aver_nu_gt1\t$aver_nu_gt1\n";
             print OUT "$i\t$aver_nu_ls1\t$aver_nu_gt1\n";
    } 
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Genome> <TE GFF> <OUT>
    <windows> <TE number>
DIE
}
