#!/usr/bin/perl -w
use strict;
use Statistics::R;

my ($region,$out)=@ARGV;
die usage() unless @ARGV==2;

open REG,"<$region" or die "$!";
my $R = Statistics::R->new();
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
open OUT,"+>$out" or die "$!";
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
    print OUT "$_\t$sd_endo\t$em_endo\t$sd_em\n";
#     $R->stopR();
}

sub fish{
    my $fish=join(",",@_); 
    $R->start_sharedR;
    $R->send(qq`dmr<-c($fish)\ndim(dmr)=c(2,2)\nreport<-fisher.test(dmr)\nprint(report)\n`);
    my $report = $R->read;
    my ($p_value)=$report=~/p-value\s+[=<>]\s+(.*)\nalternative/;
    
    return $p_value;
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Regions>
    OUTPUT: <Tissues seedlings_endosperm embryo_endosperm seedlings_embryo)
DIE
}
