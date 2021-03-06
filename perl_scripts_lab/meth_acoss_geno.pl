#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 6;
my ($geno_len,$windows,$step,$alle1_ot,$alle1_ob,$out)=@ARGV;

open LEN,$geno_len or die "$!";
my %hash;
while(<LEN>){
    chomp;
    my ($chr,$len)=split;
    next if $chr !~ /\d/;
    $hash{$chr}=$len;
}

my %meth_alle1;
foreach my $bed ($alle1_ot,$alle1_ob){
    open ALLE1,"zcat $bed|" or die "$!";
    while(<ALLE1>){
        chomp;
        my ($chr,$pos1,$pos2,$depth,$lev)=split;
        next if $depth<3;
        @{$meth_alle1{"$chr\t$pos1"}}=($depth,$lev);
    }
    close ALLE1;
}


open OUT,"+>$out" or die "$!";
foreach my $chrom(sort keys %hash){
    for(my $i=1;$i<=$hash{$chrom}/$step-1;++$i){
        my ($stt,$end)=(($i-1)*$step+1,($i-1)*$step+$windows);
        my ($c_cover_alle1,$c_nu_alle1,$t_nu_alle1)=&get($chrom,$stt,$end);
        my $lev1 = $c_nu_alle1/($c_nu_alle1 + $t_nu_alle1 + 0.000000001) ;
        print OUT "$chrom\t$stt\t$end\t$c_cover_alle1\t$c_nu_alle1\t$t_nu_alle1\t$lev1\n";
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
    }
    return ($c_cover_alle1,$c_nu_alle1,$t_nu_alle1);
}

sub cal_CT{
    my ($depth,$lev) = @_;
    my ($c_nu,$t_nu) = (int($depth*$lev/100+0.5) , $depth - (int($depth*$lev/100+0.5)));
    return ($c_nu, $t_nu);
}

sub usage{
    my $die=<<DIE;

    Usage:perl *.pl <Geno_len> <Windows size> <Step size> <allele1 OT> <OB> <OUT>

DIE
}
