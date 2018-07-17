#!/usr/bin/perl -w
use strict;
use Text::NSP::Measures::2D::Fisher::twotailed;

die usage() unless @ARGV == 2;
my($two_alle,$fisher_p_value)=@ARGV;

open F,$two_alle or die "$!";
open P,"+>$fisher_p_value" or die "$!";
while(my $line=<F>) {
    chomp($line);
    my($chr,$stt,$end,$c_cover_alle1,$c_nu_alle1,$t_nu_alle1,$c_cover_alle2,$c_nu_alle2,$t_nu_alle2) = (split(/\s+/,$line));
    my $npp = $c_nu_alle1+$t_nu_alle1+$c_nu_alle2+$t_nu_alle2;
    my $np1 = $c_nu_alle1 + $c_nu_alle2;
    my $n1p = $c_nu_alle1 + $t_nu_alle1;
    my $n11 = $c_nu_alle1;
    my $p_value = calculateStatistic( n11=>$n11,
                                      n1p=>$n1p,
                                      np1=>$np1,
                                      npp=>$npp);
    print P "$line\t$p_value\n";
}

close F;
close P;

sub usage{
    my $die=<<DIE;
    perl *.pl <Region> <OUT>
DIE
}
