#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==2;
my ($imp,$out)=@ARGV;
#open OUT,"+>$out" or die "$!";
open IMP,$imp or die "$!";
open OUT,"+>$out" or die "$!";
while(<IMP>){
    chomp;
    my ($gene,$bm_b,$bm_m,$mb_b,$mb_m)=(split)[0,2,3,4,5];
#    my ($max)=(sort{$a<=>$b}($methlev1,$methlev2))[1];
#    next if ($meth1+$unmeth1<5 || $meth2+$unmeth2<5 ||$max<20);
    my ($fish1)=&fish($bm_b,8,$bm_m,4);
    my ($fish2)=&fish($mb_m,8,$mb_b,4);
    print OUT "$gene\t$bm_b\t$bm_m\t$mb_b\t$mb_m\t$fish1\t$fish2\n";
}

sub fish{
    my ($n11,$n21,$n12,$n22)=@_;
    open OUT1,"+>DMR_fisher$imp.R" or die "$!";
    print OUT1 "dmr<-c($n11,$n21,$n12,$n22)\ndim(dmr)=c(2,2)\nfisher.test(dmr)";
    close OUT1;
    my $report=`R --vanilla --slave <DMR_fisher$imp.R`;
    my ($p_value)=$report=~/p-value\s+=\s+(.*)\nalternative/;
    return $p_value;
}

sub usage{
    my $die=<<DIE;

    Usage:perl *.pl <Candidate IMP_gene> <OUT>
    OUTPUT:
    <Chrom> <STT> <END> <T1_methlev>  <T2_methlev> <Fiser P-value>

DIE
}
