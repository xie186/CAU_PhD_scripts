#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my ($res,$out) = @ARGV;

open OUT,"+>$out" or die "$!";
open RES,$res or die "$!";
while(<RES>){
    chomp;
    my ($chr,$stt,$end,$snp_nu,$read_bmb,$read_bmm,$read_mbb,$read_mbm) = split; 
    my $pvalue1 = &chisq($read_bmb,$read_bmm);
    my $pvalue2 = &chisq($read_mbm,$read_mbb);
    print OUT "$_\t$pvalue1\t$pvalue2\n";
}

sub chisq{
    my ($n1,$n2) = @_;
    open R,"+>test.R";
    print R "chisq.test(c($n1,$n2),p=c(2/3,1/3));";
    close R;
    my $lines= `R --vanilla --slave < test.R`;
    $lines=~/p-value \S+ (.*)/;
    return $1;
}
sub usage{
    print <<DIE;
    perl *.pl <ChIP seq reads in pDMR> 
DIE
    exit 1; 
}
