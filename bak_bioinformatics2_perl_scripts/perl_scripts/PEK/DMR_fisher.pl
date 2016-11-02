#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==2;
my ($cand,$out)=@ARGV;
#open OUT,"+>$out" or die "$!";
open CAND,$cand or die "$!";
open OUT,"+>$out" or die "$!";
while(<CAND>){
    chomp;
    my ($chr,$stt,$end,$meth1,$unmeth1,$methlev1,$meth2,$unmeth2,$methlev2)=(split)[0,1,2,3,4,5,6,7,8];
    my ($max)=(sort{$a<=>$b}($methlev1,$methlev2))[1];
    next if ($meth1+$unmeth1<5 || $meth2+$unmeth2<5 ||$max<20);
    my ($fish)=&fish($meth1,$unmeth1,$meth2,$unmeth2);
    my $print=join("\t",($chr,$stt,$end,$methlev1,$methlev2,$fish));
    print OUT "$print\n";
}

sub fish{
    my ($meth1,$unmeth1,$meth2,$unmeth2)=@_;
    open OUT1,"+>DMR_fisher$cand.R" or die "$!";
    print OUT1 "dmr<-c($unmeth1,$unmeth2,$meth1,$meth2)\ndim(dmr)=c(2,2)\nfisher.test(dmr)";
    close OUT1;
    my $report=`R --vanilla --slave <DMR_fisher$cand.R`;
    my ($p_value)=$report=~/p-value\s+=\s+(.*)\nalternative/;
    return $p_value;
}

sub usage{
    my $die=<<DIE;

    Usage:perl *.pl <Candidate DMR> <OUT>
    OUTPUT:
    <Chrom> <STT> <END> <T1_methlev>  <T2_methlev> <Fiser P-value>

DIE
}
