#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 2;

#tracking_id     class_code      nearest_ref_id  gene_id gene_short_name tss_id  locus   length  coverage        FPKM    
my ($gene_bed, $ge_pos)=@ARGV;
open GENE, $gene_bed or die "$!";
my %rec_bed;
while(<GENE>){
    chomp;
    my ($chr,$stt,$end,$gene_id, $strand) = split;
    $rec_bed{$gene_id} = "$chr\t$stt\t$end\t$gene_id\t$strand";
}
open POS,$ge_pos or die "$!";
my @aa;
while(<POS>){
    chomp;
    next if !/^AT/;
    my ($track_id, $class_code, $ref_id, $gene_id,$short_name, $tss_id, $locus,$len, $cov, $fpkm) = split;
    next if $fpkm ==0;
    push (@aa,$fpkm);
}
close POS;

my $for_r=join(',',@aa);
open OUT,"+>quantile.R" or die "$!";
print OUT "cc<-c($for_r)\nquantile(cc,probs=seq(0,1,0.1))";
my $quantile=`R --vanilla --slave <quantile.R`;
#`rm -rf quantile.R`;
$quantile=~s/(\d+)%//g;
my ($fir,$sec,$thir,$four,$five,$six,$sev,$eig,$nine,$ten)=(split(/\s+/,$quantile))[-10,-9,-8,-7,-6,-5,-4,-3,-2,-1];
print "##\t$fir,$sec,$thir,$four,$five,$six,$sev,$eig,$nine,$ten\n";

open POS,$ge_pos or die "$!";
while(<POS>){
    chomp;
    next if !/^AT/;
    my ($track_id, $class_code, $ref_id, $gene_id,$short_name, $tss_id, $locus,$len, $cov, $fpkm) = split;
    next if $fpkm ==0;
    $track_id =~ s/\.1//g;
    #my $print=join("\t",@tem);
    my $flag = "NA";
    if($fpkm<=$fir){
        $flag = 1;
    }elsif($fpkm>=$fir && $fpkm<=$sec){
        $flag = 2;
    }elsif($fpkm>$sec && $fpkm<=$thir){
        $flag = 3;
    }elsif($fpkm>$thir && $fpkm<=$four){
        $flag = 4;
    }elsif($fpkm>$four && $fpkm<=$five){
        $flag = 5;
    }elsif($fpkm>$five && $fpkm<=$six){
        $flag = 6;
    }elsif($fpkm>$six && $fpkm<=$sev){
        $flag = 7;
    }elsif($fpkm>$sev && $fpkm<=$eig){
        $flag = 8;
    }elsif($fpkm>$eig && $fpkm<=$nine){
        $flag = 9;
    }elsif($fpkm>$nine && $fpkm<$ten){
        $flag = 10;
    }else{

    }
    print "$rec_bed{$track_id}\t$flag\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <gene position bed> <cufllinks fpkm results> 
    Rank to five groups based on gene expression level.
DIE
}
