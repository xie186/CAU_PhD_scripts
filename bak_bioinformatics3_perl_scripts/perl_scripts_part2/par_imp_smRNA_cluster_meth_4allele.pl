#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 6;
my ($alle1, $alle2, $alle3, $alle4, $imp_smRNA_cluster, $out)=@ARGV;

my %meth_alle1;
open ALLE1,$alle1 or die "$!";
while(<ALLE1>){
    chomp;
    my ($chr,$pos1,$pos2,$depth,$lev)=split;
    next if $depth<3;
    @{$meth_alle1{"$chr\t$pos1"}}=($depth,$lev);
}

my %meth_alle2;
open ALLE2,$alle2 or die "$!";
while(<ALLE2>){
    chomp;
    my ($chr,$pos1,$pos2,$depth,$lev)=split;
    next if $depth<3;
    @{$meth_alle2{"$chr\t$pos1"}}=($depth,$lev);
}

my %meth_alle3;
open ALLE1,$alle3 or die "$!";
while(<ALLE1>){
    chomp;
    my ($chr,$pos1,$pos2,$depth,$lev)=split;
    next if $depth<3;
    @{$meth_alle3{"$chr\t$pos1"}}=($depth,$lev);
}

my %meth_alle4;
open ALLE1,$alle4 or die "$!";
while(<ALLE1>){
    chomp;
    my ($chr,$pos1,$pos2,$depth,$lev)=split;
    next if $depth<3;
    @{$meth_alle4{"$chr\t$pos1"}}=($depth,$lev);
}

open OUT,"+>$out" or die "$!";
open IMP,$imp_smRNA_cluster or die "$!";
while(<IMP>){
    chomp;
    my ($chr, $stt, $end) = split(/\t/,$_);
#        my ($c_cover_alle1,$c_nu_alle1,$t_nu_alle1,$c_cover_alle2,$c_nu_alle2,$t_nu_alle2,$c_cover_alle3,$c_nu_alle3,$t_nu_alle3,$c_cover_alle4,$c_nu_alle4,$t_nu_alle4)=&get($chrom,$stt,$end);
    my ($c_cover_alle1,$c_nu_alle1,$t_nu_alle1) = &get($chr,$stt,$end,\%meth_alle1);
    my ($c_cover_alle2,$c_nu_alle2,$t_nu_alle2) = &get($chr,$stt,$end,\%meth_alle2);
    my ($c_cover_alle3,$c_nu_alle3,$t_nu_alle3) = &get($chr,$stt,$end,\%meth_alle3);
    my ($c_cover_alle4,$c_nu_alle4,$t_nu_alle4) = &get($chr,$stt,$end,\%meth_alle4);
    next if ($c_cover_alle1<5 || $c_cover_alle2 < 5 || $c_cover_alle3 < 5 || $c_cover_alle4 < 5);
    my ($mth_lev1, $mth_lev2, $mth_lev3, $mth_lev4) = ($c_nu_alle1 / ($c_nu_alle1 + $t_nu_alle1), $c_nu_alle2 / ($c_nu_alle2 + $t_nu_alle2), $c_nu_alle3/($c_nu_alle3+$t_nu_alle3), $c_nu_alle4 / ($c_nu_alle4 + $t_nu_alle4));
    print OUT "$_\t$c_cover_alle1\t$c_nu_alle1\t$t_nu_alle1\t$c_cover_alle2\t$c_nu_alle2\t$t_nu_alle2\t$c_cover_alle3\t$c_nu_alle3\t$t_nu_alle3\t$c_cover_alle4\t$c_nu_alle4\t$t_nu_alle4\t$mth_lev1\t$mth_lev2\t$mth_lev3\t$mth_lev4\n";
}

sub get{
    my ($chrom,$stt,$end,$hash_alle_ref)=@_;
    my ($c_cover_alle1,$c_nu_alle1,$t_nu_alle1)=(0,0,0,0,0,0);
    for(my $i=$stt;$i<=$end;++$i){
        if(exists $hash_alle_ref->{"$chrom\t$i"}){
            my ($c_nu, $t_nu) = &cal_CT(@{$hash_alle_ref->{"$chrom\t$i"}});
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
#    print "$depth,$lev \t $c_nu, $t_nu \n";
    return ($c_nu, $t_nu);
}

sub usage{
    my $die=<<DIE;
    Usage:perl *.pl <Geno_len> <Windows size> <Step size> <allele BMM> <allele BMM> <allele MBM> <allele MBM> <OUT> 
    OUTPUT:
	<Chrom>	
	<STT>
	<END>
	{allele BMB <# of Cs covered by reads> <# of Cs sequenced in window> <# of Ts>}
	{allele BMM <# of Cs covered by reads> <# of Cs sequenced in window> <# of Ts>}
        {allele MBB <# of Cs covered by reads> <# of Cs sequenced in window> <# of Ts>}
        {allele MBM <# of Cs covered by reads> <# of Cs sequenced in window> <# of Ts>}
DIE
}
