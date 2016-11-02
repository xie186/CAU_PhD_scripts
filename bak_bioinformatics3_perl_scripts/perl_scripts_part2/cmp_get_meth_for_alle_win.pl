#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 6;
my ($geno_len,$windows,$step,$ot,$ob,$out)=@ARGV;

open LEN,$geno_len or die "$!";
my %hash_geno;
while(<LEN>){
    chomp;
    next if (/^chr0/ || /^chr11/ || /^chr12/);
    my ($chr,$len)=split;
    $hash_geno{$chr}=$len;
}

my %meth;
open OT,$ot or die "$!";
while(<OT>){
    chomp;
    my ($chr,$pos1,$pos2,$depth,$lev)=split;
    next if $depth<3;
    @{$meth{"$chr\t$pos1"}} = ($depth,$lev);
}

open OB,$ob or die "$!";
while(<OB>){
    chomp;
    my ($chr,$pos1,$pos2,$depth,$lev)=split;
    next if $depth<3;
    @{$meth{"$chr\t$pos1"}} = ($depth,$lev);
}

open OUT,"+>$out" or die "$!";
foreach my $chrom(sort keys %hash_geno){
    for(my $i=1;$i<=$hash_geno{$chrom}/$step-1;++$i){
        my ($stt,$end)=(($i-1)*$step+1,($i-1)*$step+$windows);
        my ($c_cover,$c_nu, $t_nu)=&get($chrom,$stt,$end);
        next if ($c_cover < 5 );
        my $lev = $c_nu / ($c_nu + $t_nu);
        print OUT "$chrom\t$stt\t$end\t$c_nu\t$t_nu\t$lev\n";
    }
}

sub get{
    my ($chrom,$stt,$end)=@_;
    my ($c_cover,$c_nu,$t_nu)=(0,0,0);
    for(my $i=$stt;$i<=$end;++$i){
        if(exists $meth{"$chrom\t$i"}){
            my ($c_nu_tem, $t_nu_tem) = &cal_CT(@{$meth{"$chrom\t$i"}});
            $c_nu += $c_nu_tem;
            $t_nu += $t_nu_tem;
            ++ $c_cover;
        }
    }
    return ($c_cover,$c_nu,$t_nu);
}

sub cal_CT{
    my ($depth,$lev) = @_;
    my ($c_nu,$t_nu) = (int($depth*$lev/100+0.5) , $depth - (int($depth*$lev/100+0.5)));
#    print "$depth,$lev \t $c_nu, $t_nu \n";
    return ($c_nu, $t_nu);
}

sub usage{
    my $die=<<DIE;

    Usage:perl *.pl <Geno_len> <Windows size> <Step size> <OT> <OB><OUT>
    OUTPUT:
    <Chrom> <STT> <END> <# of Cs covered by reads> <# of C sequenced>  <# of T sequenced> <Average meth_lev> 

DIE
}
