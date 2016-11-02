#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 3;
my ($snp,$vcf,$inbred) = @ARGV;
open SNP,$snp or die "$!";
my $header = <SNP>;
chomp $header;
my ($CHROM,$POS, $REF,$Zheng58,$in5003,$in478,$in8112) = split(/\t/,$header);
my $index = "NA";
if($inbred eq "5003"){
    $index = 1;
}elsif($inbred eq "8112"){
    $index = 3;
}else{
    die "$inbred NOT right!!\n"
}
my %snp_pos;
while(<SNP>){
    my ($chr,$pos,$ref,@geno) = split;
    ($Zheng58,$in5003,$in478,$in8112) = @geno;
    next if /x/i;
    if($in5003 ne $in8112){
        $snp_pos{"$chr\t$pos"} = "$ref\t$geno[$index]";
    }
}

print "chr\tpos\tref\t$inbred\t$inbred\_RNA_seq\n";
open VCF,$vcf or die "$!";
while(<VCF>){
    chomp;
    next if /^#/;
    #chr0    1560620 .       G       A       229     .       DP=9;VDB=0.0320;AF1=1;AC1=4;DP4=0,0,7,2;MQ=44;FQ=-37.6  GT:PL:GQ
    next if !/1\/1/;
    my ($chr,$pos,$dot1,$ref,$alt,$qual,$dot2,$id,$pl,$ps_val) = split;
    next if /INDEL/;
    if(exists $snp_pos{"$chr\t$pos"}){
        print "$chr\t$pos\t$snp_pos{\"$chr\t$pos\"}\t$alt\n";
    }
}

sub usage{
    my $die =<<DIE;
    perl *.pl <snp> <vcf> <inbred [8112 5003]>
DIE
}
