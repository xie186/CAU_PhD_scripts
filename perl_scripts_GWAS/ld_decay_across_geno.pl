#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==4;
my ($geno_len,$chrom,$bim_prefix,$win) = @ARGV;
my $bin = 100;
open LEN,$geno_len or die "$!";
my %hash_len;
while(<LEN>){
     chomp; 
     my ($chr,$len ) = split;
     $hash_len{$chr} = $len;
}

my $nu = int ($hash_len{$chrom} / $win +1);
`mkdir ./ld_cal` if !-e "./ld_cal";
for(my $i = 1;$i<=$nu;++$i){
    my ($stt,$end) = (($i-1)*$win, $i*$win);
    $chrom =~ s/chr//g if $chrom=~/chr/;
    my $win_kb = $win/1000;
    my $win_left = $win -1;
    ### maf 0.03
    `/NAS2/jiaoyp/software/plink-1.07-x86_64/plink --bfile $bim_prefix --noweb --r2 --ld-window-kb 200 --ld-window 199999 --ld-window-r2 0 --maf 0.03 --chr $chrom --from-bp $stt --to-bp $end --out ./ld_cal/chr$chrom\_$stt\_$end\_win$win` if !-e "./ld_cal/chr$chrom\_$stt\_$end\_win$win.ld";  
    open LD,"./ld_cal/chr$chrom\_$stt\_$end\_win$win.ld" or die "$!";
    my %ld_decay;
    while(<LD>){
        next if /CHR/;
        chomp;
        my ($chr1,$pos1,$index1,$chr2,$pos2,$index2,$r_sq) = split;
        #print "$chr1,$pos1,$index1,$chr2,$pos2,$index2,$r_sq\n";
        my $win_nu = int (($pos2-$pos1+1)/$bin) + 1;
        $ld_decay{$win_nu}[0] ++;
        $ld_decay{$win_nu}[1] += $r_sq;
    }
    foreach(sort{$a<=>$b}keys %ld_decay){
        my $pos = $_*$bin - $bin/2;
        my $aver_ld = $ld_decay{$_}[1] / $ld_decay{$_}[0];
        print "$chrom\t$stt\t$end\t$pos\t$aver_ld\n";
    }
    `rm ./ld_cal/chr$chrom\_$stt\_$end\_win$win.ld`;
}

sub usage{
    my $die =<<DIE;
    perl *.pl <geno len> <chrom> <bim prefix> <win >
    MAF: 0.03
DIE
}
