#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 4;
my ($geno_len,$windows,$step,$dms)=@ARGV;

open LEN,$geno_len or die "$!";
my %hash;
while(<LEN>){
    chomp;
    my ($chr,$len)=split;
    next if $chr !~ /\d/;
    $hash{$chr}=$len;
}

my %dms;
open DMS,$dms or die "$!";
while(<DMS>){
    chomp;
    my ($chr,$stt,$end,$geno1_c,$geno1_t,$geno2_c,$geno2_t,$lev1,$lev2,$diff,$pval,$qval, $stat) = split;
    $dms{"$chr\t$stt"} = $stat;
}

foreach my $chrom(sort keys %hash){
    for(my $i=1;$i<=$hash{$chrom}/$step-1;++$i){
        my ($stt,$end)=(($i-1)*$step+1,($i-1)*$step+$windows);
        my ($dms_num, $stab_num)=&get($chrom,$stt,$end);
        print "$chrom\t$stt\t$end\t$dms_num\t$stab_num\n";
    }
}

sub get{
    my ($chrom,$stt,$end)=@_;
    my ($dms_num, $dms_stab)=(0,0);
    for(my $i=$stt;$i<=$end;++$i){
        if(exists $dms{"$chrom\t$i"}){
            ++$dms_num;
            ++ $dms_stab if $dms{"$chrom\t$i"} eq "S";
        }
    }
    return ($dms_num, $dms_stab);
}

sub usage{
    my $die=<<DIE;

    Usage:perl *.pl <Geno_len> <Windows size> <Step size> <DMS> <OUT> 

DIE
}
