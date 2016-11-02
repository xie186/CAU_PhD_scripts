#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==6;

my ($alle1,$alle2,$alle3,$alle4,$region,$out) = @ARGV;
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
open ALLE3,$alle3 or die "$!";
while(<ALLE3>){
    chomp;
    my ($chr,$pos1,$pos2,$depth,$lev)=split;
    next if $depth<3;
    @{$meth_alle3{"$chr\t$pos1"}}=($depth,$lev);
}
my %meth_alle4;
open ALLE4,$alle4 or die "$!";
while(<ALLE4>){
    chomp;
    my ($chr,$pos1,$pos2,$depth,$lev)=split;
    next if $depth<3;
    @{$meth_alle4{"$chr\t$pos1"}}=($depth,$lev);
}

open OUT,"+>$out" or die "$!";
open REGION,$region or die "$!";
while(<REGION>){
    chomp;
    my ($chr,$stt,$end) = split;
    my ($c_cover_alle1,$c_nu_alle1,$t_nu_alle1,$c_cover_alle2,$c_nu_alle2,$t_nu_alle2, $c_cover_alle3,$c_nu_alle3,$t_nu_alle3,$c_cover_alle4,$c_nu_alle4,$t_nu_alle4) = &get($chr,$stt,$end);
    next if ($c_cover_alle1 / ($end-$stt+1) < 5/200 || $c_cover_alle2 / ($end-$stt+1) < 5/200 || $c_cover_alle3 / ($end-$stt+1) < 5/200 || $c_cover_alle4 / ($end-$stt+1) < 5/200);
    my ($mth_lev1,$mth_lev2,$mth_lev3,$mth_lev4) = ($c_nu_alle1/($c_nu_alle1+$t_nu_alle1), $c_nu_alle2/($c_nu_alle2+$t_nu_alle2), $c_nu_alle3/($c_nu_alle3+$t_nu_alle3), $c_nu_alle4/($c_nu_alle4+$t_nu_alle4));
    print OUT "$_\t$c_cover_alle1\t$c_nu_alle1\t$t_nu_alle1\t$c_cover_alle2\t$c_nu_alle2\t$t_nu_alle2\t$c_cover_alle3\t$c_nu_alle3\t$t_nu_alle3\t$c_cover_alle4\t$c_nu_alle4\t$t_nu_alle4\t$mth_lev1\t$mth_lev2\t$mth_lev3\t$mth_lev4\n";
#    print OUT "$_\t$c_cover_alle1\t$c_nu_alle1\t$t_nu_alle1\t$c_cover_alle2\t$c_nu_alle2\t$t_nu_alle2\t $c_cover_alle3\t$c_nu_alle3\t$t_nu_alle3\t$c_cover_alle4\t$c_nu_alle4\t$t_nu_alle4\n";
}

sub get{
    my ($chrom,$stt,$end)=@_;
    my ($c_cover_alle1,$c_nu_alle1,$t_nu_alle1,$c_cover_alle2,$c_nu_alle2,$t_nu_alle2,$c_cover_alle3,$c_nu_alle3,$t_nu_alle3,$c_cover_alle4,$c_nu_alle4,$t_nu_alle4)=(0,0,0,0,0,0,0,0,0,0,0,0);
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
        if(exists $meth_alle3{"$chrom\t$i"}){
            my ($c_nu, $t_nu) = &cal_CT(@{$meth_alle3{"$chrom\t$i"}});
            $c_nu_alle3 += $c_nu;
            $t_nu_alle3 += $t_nu;
            ++ $c_cover_alle3;
        }
        if(exists $meth_alle4{"$chrom\t$i"}){
            my ($c_nu, $t_nu) = &cal_CT(@{$meth_alle4{"$chrom\t$i"}});
            $c_nu_alle4 += $c_nu;
            $t_nu_alle4 += $t_nu;
            ++ $c_cover_alle4;
        }
    }
#    next if ($c_cover_alle1 ==0 || $c_cover_alle2==0 || $c_cover_alle3==0 || $c_cover_alle4==0);
    return ($c_cover_alle1,$c_nu_alle1,$t_nu_alle1,$c_cover_alle2,$c_nu_alle2,$t_nu_alle2, $c_cover_alle3,$c_nu_alle3,$t_nu_alle3,$c_cover_alle4,$c_nu_alle4,$t_nu_alle4);
}

sub cal_CT{
    my ($depth,$lev) = @_;
    my ($c_nu,$t_nu) = (int($depth*$lev/100+0.5) , $depth - (int($depth*$lev/100+0.5)));
    return ($c_nu, $t_nu);
}

sub usage{
    my $die=<<DIE;
    perl *.pl  <BM_B> <BM_M> <MB_B> <MB_M> <Regions> <OUT>
DIE
}
