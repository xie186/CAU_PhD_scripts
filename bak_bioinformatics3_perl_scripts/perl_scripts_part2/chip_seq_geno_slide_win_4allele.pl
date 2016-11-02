#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 5;
my ($geno_len, $windows, $step, $chip_read_4alle, $out)=@ARGV;

open INFO,$chip_read_4alle or die "$!";
my %hash_chip;
### Allelic number of ChIP_seq reads on the SNP postion.
while(<INFO>){
    chomp;
    my ($chr,$pos,$alle1,$alle2,$alle3,$alle4) = split;
    push @{$hash_chip{"$chr\t$pos"}},($alle1,$alle2,$alle3,$alle4);
}

open LEN,$geno_len or die "$!";
my %hash;
while(<LEN>){
    chomp;
    next if (/^chr0/ || /^chr11/ || /^chr12/);
    my ($chr,$len)=split;
    $hash{$chr}=$len;
}

open OUT,"+>$out" or die "$!";
foreach my $chrom(sort keys %hash){
    for(my $i=1;$i<=$hash{$chrom}/$step-1;++$i){
        my ($stt,$end)=(($i-1)*$step+1,($i-1)*$step+$windows);
        my ($snp_nu,$nu_bmb, $nu_bmm, $nu_mbb,$nu_mbm)=&get($chrom,$stt,$end);
        $nu_bmb = 0 if $nu_bmb <0;
        $nu_bmm = 0 if $nu_bmm <0;
        $nu_mbb = 0 if $nu_mbb <0;
        $nu_mbm = 0 if $nu_mbm <0;
        print OUT "$chrom\t$stt\t$end\t$snp_nu\t$nu_bmb\t$nu_bmm\t$nu_mbb\t$nu_mbm\n";
    }
}

sub get{
    my ($chrom,$stt,$end)=@_;
    my ($snp_nu,$nu_bmb, $nu_bmm, $nu_mbb,$nu_mbm) = (0,0,0,0,0);
    for(my $i=$stt;$i<=$end;++$i){
        if(exists $hash_chip{"$chrom\t$i"}){
            my ($alle1,$alle2,$alle3,$alle4) = @{$hash_chip{"$chrom\t$i"}};
            $snp_nu ++;
            $nu_bmb += $alle1;
            $nu_bmm += $alle2;
            $nu_mbb += $alle3;
            $nu_mbm += $alle4;
        }
    }
    return ($snp_nu,$nu_bmb, $nu_bmm, $nu_mbb,$nu_mbm);
}

sub usage{
    my $die=<<DIE;

    Usage:perl *.pl <Geno_len> <Windows size> <Step size> <chip_reads_4allele> <OUT>
    OUTPUT:
    <Chrom> <STT> <END> <SNP number in the window> <BMB> <BMM> <MBB> <MBM>

DIE
}
