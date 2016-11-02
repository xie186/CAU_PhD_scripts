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
print OUT "cc<-c($for_r)\nquantile(cc,probs=seq(0,1,0.2))";
my $quantile=`R --vanilla --slave <$gff.quantile.R`;
`rm -rf $gff.quantile.R`;
my ($fir,$sec,$thir,$four,$five)=(split(/\s+/,$quantile))[-5,-4,-3,-2,-1];

#print "$fir,$sec,$thir,$four,$five\n";
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
    }else{
#        print "$_\t5\n";
    }
}
sub usage{
    my $die=<<DIE;
    perl *.pl <GFF expressed>
DIE
}
