#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==3;

my($two_alle,$fisher_R,$fisher_p_value)=@ARGV;

open F,$two_alle or die "$!";
open P,"+>$fisher_p_value" or die "$!";
while(my $line=<F>) {
    chomp($line);
    
    my($chr,$stt,$end,$c_cover_alle1,$c_nu_alle1,$t_nu_alle1,$c_cover_alle2,$c_nu_alle2,$t_nu_alle2) = (split(/\s+/,$line));
    my $p_value = &fisher($c_nu_alle1,$t_nu_alle1,$c_nu_alle2,$t_nu_alle2);
    print P "$line\t$p_value\n";
}

sub fisher{
    my ($c_nu_alle1,$t_nu_alle1,$c_nu_alle2,$t_nu_alle2) = @_;
    open O,"+>$fisher_R" or die "$!";
    print O "rpkm<-c($c_nu_alle1,$c_nu_alle2,$t_nu_alle1,$t_nu_alle2)\ndim(rpkm)=c(2,2)\nfisher.test(rpkm)\$p\n";
    close O;
    my $report=`R --vanilla --slave <$fisher_R`;
    my $p_value=(split(/\s+/,$report))[1];
    
}

close F;
close P;

sub usage{
    my $die=<<DIE;

    perl *.pl <Region> <Fisher temperary file> <OUT>

DIE
}
