#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 5;
my ($geno_len, $gene, $win_size, $step_size, $out) = @ARGV;

open LEN,$geno_len or die "$!";
my %hash;
while(<LEN>){
    chomp;
    my ($chr,$len)=split;
    next if $chr !~ /\d/;
    $hash{$chr}=$len;
}

open GENE, $gene or die "$!";
my %rec_gene;
while(<GENE>){
        chomp;
        my ($chr,$stt,$end)=split;
        my $mid = int (($stt+$end)/2);
        $rec_gene{"$chr\t$mid"} ++;
}
close GENE;

my $max = 0;
my %rec_gene_num;
foreach my $chrom(sort keys %hash){
    for(my $i=1;$i<=$hash{$chrom}/$step_size-1;++$i){
        my ($stt,$end)=(($i-1)*$step_size+1,($i-1)*$step_size+$win_size);
        my $gene_num = &get($chrom,$stt,$end);
        $rec_gene_num{"$chrom\t$stt\t$end"} = $gene_num;
    }
}

open OUT,"|sort -k1,1 -k2,2n >$out" or die "$!";
foreach(keys %rec_gene_num){
    my $dens = $rec_gene_num{$_}/$max;
    print OUT "$_\t$dens\n";
}
close OUT;

sub get{
    my ($chrom,$stt,$end)=@_;
    my $gene_num = 0; 
    for(my $i=$stt;$i<=$end;++$i){
        if(exists $rec_gene{"$chrom\t$i"}){
            ++ $gene_num;
        }
    }
    $max = $gene_num if $max < $gene_num;
    return $gene_num;
}

sub usage{
    my $die=<<DIE;

    Usage:perl *.pl <Geno_len> <DMS> <Windows size> <Step size> <OUT>

DIE
}
