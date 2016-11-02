#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==1;
my ($gff)=@ARGV;
open GFF,$gff or die "$!";
my %rpkm;my @aa;
while(<GFF>){
    chomp;
    my ($chr,$ele,$stt1,$end1,$strand,$name,$rpkm)=(split);
    push (@aa,$rpkm) if !exists $rpkm{$name};
    $rpkm{$name}=$rpkm;
}
close GFF;
my $for_r=join(',',@aa);
open OUT,"+>$gff.quantile.R" or die "$!";
print OUT "cc<-c($for_r)\nquantile(cc,probs=seq(0,1,0.1))";
my $quantile=`R --vanilla --slave <$gff.quantile.R`;
`rm -rf $gff.quantile.R`;
$quantile=~s/(\d+)%//g;
my ($fir,$sec,$thir,$four,$five,$six,$sev,$eig,$nine,$ten)=(split(/\s+/,$quantile))[-10,-9,-8,-7,-6,-5,-4,-3,-2,-1];

#print "$fir,$sec,$thir,$four,$five,$six,$sev,$eig,$nine,$ten\n";
open GFF,$gff or die "$!";
while(<GFF>){
    chomp;
    my ($chr,$ele,$stt1,$end1,$strand,$name,$rp)=split;
    if($rp<=$fir){
        print "$_\t1\n";
    }elsif($rp>=$fir && $rp<=$sec){
        print "$_\t2\n";
    }elsif($rp>$sec && $rp<=$thir){
        print "$_\t3\n";
    }elsif($rp>$thir && $rp<=$four){
        print "$_\t4\n";
    }elsif($rp>$four && $rp<=$five){
        print "$_\t5\n";
    }elsif($rp>$five && $rp<=$six){
        print "$_\t6\n";
    }elsif($rp>$six && $rp<=$sev){
        print "$_\t7\n";
    }elsif($rp>$sev && $rp<=$eig){
        print "$_\t8\n";
    }elsif($rp>$eig && $rp<=$nine){
        print "$_\t9\n";
    }elsif($rp>$nine && $rp<$ten){
        print "$_\t10\n";
    }else{

    }
}

sub usage{
    my $die=<<DIE;
    perl *.pl <GFF expressed>
DIE
}
