#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 6;
my ($geno_len,$windows,$step,$alle1,$alle2,$out)=@ARGV;

open LEN,$geno_len or die "$!";
my %hash;
while(<LEN>){
    chomp;
    next if (/^chr0/ || /^chr11/ || /^chr12/);
    my ($chr,$len)=split;
    $hash{$chr}=$len;
}

my %meth_alle1;
open ALLE1,$alle1 or die "$!";
while(<ALLE1>){
    chomp;
    my ($chr,$pos,$c_depth,$t_depth)=split;
    next if $c_depth+$t_depth<5;
    @{$meth_alle1{"$chr\t$pos"}}=($c_depth,$t_depth);
}

my %meth_alle2;
open ALLE2,$alle2 or die "$!";
while(<ALLE2>){
    chomp;
    my ($chr,$pos,$c_depth,$t_depth)=split;
    next if $c_depth+$t_depth<5;
    @{$meth_alle2{"$chr\t$pos"}}=($c_depth,$t_depth);
}

open OUT,"+>$out" or die "$!";
foreach my $chrom(sort keys %hash){
    for(my $i=1;$i<=$hash{$chrom}/$step-1;++$i){
        my ($stt,$end)=(($i-1)*$step+1,($i-1)*$step+$windows);
        my ($c_cover_alle1,$c_nu_alle1,$t_nu_alle1,$c_cover_alle2,$c_nu_alle2,$t_nu_alle2)=&get($chrom,$stt,$end);
        next if ($c_cover_alle1 < 5 || $c_cover_alle2 < 5);
        my $methylevel1 = 100*$c_nu_alle1/($c_nu_alle1+$t_nu_alle1);
        my $methylevel2 = 100*$c_nu_alle2/($c_nu_alle2+$t_nu_alle2);
        my $diff = $methylevel1 - $methylevel2;
        print OUT "$chrom\t$stt\t$end\t$c_cover_alle1\t$c_nu_alle1\t$t_nu_alle1\t$c_cover_alle2\t$c_nu_alle2\t$t_nu_alle2\t$methylevel1\t$methylevel2\t$diff\n";
    }
}

sub get{
    my ($chrom,$stt,$end)=@_;
    my ($c_cover_alle1,$c_nu_alle1,$t_nu_alle1,$c_cover_alle2,$c_nu_alle2,$t_nu_alle2)=(0,0,0,0,0,0);
    for(my $i=$stt;$i<=$end;++$i){
        if(exists $meth_alle1{"$chrom\t$i"}){
            my ($c_nu, $t_nu) = &cal_CT(@{$meth_alle1{"$chrom\t$i"}});
            $c_nu_alle1 += $c_nu;
            $t_nu_alle1 += $t_nu;
            ++ $c_cover_alle1;
        }
        if(exists $meth_alle2{"$chrom\t$i"}){
            my ($c_nu, $t_nu) = &cal_CT(@{$meth_alle2{"$chrom\t$i"}});
            $c_nu_alle2 += $c_nu;
            $t_nu_alle2 += $t_nu;
            ++ $c_cover_alle2;
        }
    }
    return ($c_cover_alle1,$c_nu_alle1,$t_nu_alle1,$c_cover_alle2,$c_nu_alle2,$t_nu_alle2);
}

sub cal_CT{
    my ($c_depth,$t_depth) = @_;
    my ($c_nu,$t_nu) = ($c_depth,$t_depth);
#    print "$depth,$lev \t $c_nu, $t_nu \n";
    return ($c_nu, $t_nu);
}

sub usage{
    my $die=<<DIE;

    Usage:perl *.pl <Geno_len> <Windows size> <Step size> <allele1> <allele2> <OUT>
    OUTPUT:
    <Chrom> <STT> <END> {allele1 <# of Cs covered by reads> <# of Cs sequenced in window> <# of Ts>} {allele2 <# of Cs covered by reads> <# of Cs sequenced in window> <# of Ts>}

DIE
}
