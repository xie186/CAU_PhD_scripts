#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my ($vcf,$snp_qc) = @ARGV;
open VCF,$vcf or die "$!";
while(<VCF>){
    next if (/^##/ || /INDEL/);
    chomp;
    if(/^#/){
        my ($chr,$pos,$id,$ref,$alt,$qual,$filter,$infor,$format,@inbred) = split;
        my $tem_inbred = join("\t",@inbred);
        print "$chr\t$pos\t$ref\t$tem_inbred\n";
    }else{
        my @tem_geno;
        my ($chr,$pos,$id,$ref,$alt,$qual,$filter,$infor,$format,@geno) = split(/\t/);
        next if ($qual <=$snp_qc || (length $alt) != 1);
#        next if ($qual <=$snp_qc); 
#        GT:PL:DP:SP:GQ 
        foreach my $geno(@geno){
            my ($GT,$PL,$DP,$SP,$GQ) = $geno =~ /(.*):(.*):(.*):(.*):(.*)/;
            if($DP ==0){
                push @tem_geno,"x";
            }elsif($DP > 0 && $GT =~ /0\/0/){
                push @tem_geno,$ref;
            }elsif($DP > 0 && $geno =~ /1\/1/){
                push @tem_geno,$alt;
            }elsif($DP > 0 && $geno =~ /0\/1/){
                push @tem_geno,"X";
            }
        }
        my $tem_geno = join("\t",@tem_geno);
        print "$chr\t$pos\t$ref/$alt\t$tem_geno\n";
    }
}

sub usage{
    my $die =<<DIE;
    perl *.pl <VCF> <SNP quality>
DIE
}
