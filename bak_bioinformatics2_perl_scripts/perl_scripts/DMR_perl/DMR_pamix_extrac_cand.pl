#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==4;
my ($endosd,$len_cut,$over_cut,$sd_mth_cut)=@ARGV;

open ENDOSD,$endosd or die "$!";
while(<ENDOSD>){
    chomp;
    my ($chr,$stt,$end,$lap_nu,$c_nu,$endo_lev,$sd_c_nu,$sd_lev)=split;
    my $ratio=$lap_nu/(($end-$stt+1-200)/20+0.000001);
    if($end-$stt+1>=$len_cut && $ratio>=$over_cut && $sd_lev>$sd_mth_cut){
        print "$_\n";
    }
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Endo & seedlings meth> <Length Cutoff> <Over Number 0-1> <Seedlins methlation level cutoff>
DIE
}

