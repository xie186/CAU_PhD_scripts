#!/usr/bin/perl -w
use strict;
my ($region)=@ARGV;
use Text::NSP::Measures::2D::Fisher2::twotailed;
die usage() unless @ARGV==1;
open REG,$region or die "$!";
my ($tol_sd,$tol_em,$tol_endo)=(0,0,0);
while(<REG>){
    chomp;
    my ($chr,$stt,$end,$sd_nu,$sd_lev,$em_nu,$em_lev,$endo_nu,$endo_lev)=split;
    next if ($sd_nu<5 ||$em_nu<5||$endo_nu<5);
    $tol_sd+=$sd_lev;
    $tol_em+=$em_lev;
    $tol_endo+=$endo_lev;
}
close REG;

open REG,$region or die "$!";
while(<REG>){
    chomp;
    my ($chr,$stt,$end,$sd_nu,$sd_lev,$em_nu,$em_lev,$endo_nu,$endo_lev)=split;
    ###    seedlings_endosperm 
    my ($sd_endo,$em_endo,$sd_em)=("NA","NA","NA");
    
    if($sd_nu>=5 && $endo_nu>=5){
        $sd_endo=&fish($sd_lev,$tol_sd,$endo_lev,$tol_endo);
    }
    if($em_nu>=5 && $endo_nu>=5){
         $em_endo=&fish($em_lev,$tol_em,$endo_lev,$tol_endo);
    }
    
    if($em_nu>=5 && $sd_nu>=5){
         $sd_em=&fish($sd_lev,$tol_sd,$em_lev,$tol_em);
    }
    print "$_\t$sd_endo\t$em_endo\t$sd_em\n";
}

sub fish{
    my ($n11,$n21,$n12,$n22)=@_;
    ($n11,$n21,$n12,$n22)=(int($n11+0.5),int($n21+0.5),int($n12+0.5),int($n22+0.5));
    my $npp = $n11+$n21+$n12+$n22; my $n1p = $n11+$n12; my $np1 = $n11+$n21;
    
    my $twotailed_value = calculateStatistic( n11=>$n11,
                                      n1p=>$n1p,
                                      np1=>$np1,
                                      npp=>$npp);
    return $twotailed_value;
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Regions>
    OUTPUT: <Tissues seedlings_endosperm embryo_endosperm seedlings_embryo)
DIE
}
