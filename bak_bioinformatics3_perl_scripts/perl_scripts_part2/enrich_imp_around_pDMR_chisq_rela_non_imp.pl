#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my ($res, $pDMR_tot) = @ARGV;

open RES,$res or die "$!";
<RES>;
while(<RES>){
    chomp;
    my ($mat,$pat,$random_mat,$random_pat)  = split;
#    my $pvalue1 = &chisq($mat, $pDMR_tot, $random_mat, $random_nu);
#    my $pvalue2 = &chisq($pat, $pDMR_tot, $random_pat, $random_nu);
    my $pvalue1 = &chisq($mat, $random_mat, $pDMR_tot, $pDMR_tot);
    my $pvalue2 = &chisq($pat, $random_pat, $pDMR_tot, $pDMR_tot);
    print "$_\t$pvalue1\t$pvalue2\n";
}

sub chisq{
    my ($n11,$n12,$n21,$n22) = @_;
    open R,"+>test.R";
    print R "cc<-c($n11,$n21,$n12,$n22);dim(cc)<-c(2,2);chisq.test(cc);";
    close R;
    my $report = `R --vanilla --slave < test.R`;
    $report =~ /p-value\s+[=<>]\s+(.*)\n/;
    return $1;
}
sub usage{
    print <<DIE;
    perl *.pl <enrichment results> <number of pDMR or gDMR> 
DIE
    exit 1; 
}
