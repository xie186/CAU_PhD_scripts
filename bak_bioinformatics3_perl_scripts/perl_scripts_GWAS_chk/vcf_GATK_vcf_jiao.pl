#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 1;
my ($vcf) = @ARGV;
open VCF,$vcf or die "$!";
while(<VCF>){
    next if /^##/;
    chomp;
    if(/^#/){
        my ($chr,$pos,$id,$ref,$alt,$qual,$filter,$infor,$format,@inbred) = split;
        my $tem_inbred = join("\t",@inbred);
        print "$chr\t$pos\t$ref\t$tem_inbred\n";
    }else{
        my @tem_geno;
        my ($chr,$pos,$id,$ref,$alt,$qual,$filter,$infor,$format,@geno) = split(/\t/);
        foreach my $geno(@geno){
            if($geno =~ /\.\/\./){
                push @tem_geno,"x";
            }elsif($geno =~ /0\/0/){
                push @tem_geno,$ref;
            }elsif($geno =~ /1\/1/){
                push @tem_geno,$alt;
            }elsif($geno =~ /0\/1/){
                push @tem_geno,"X";
            }
        }
        my $tem_geno = join("\t",@tem_geno);
        print "$chr\t$pos\t$ref/$alt\t$tem_geno\n";
    }
}

sub usage{
    my $die =<<DIE;
    perl *.pl <VCF>
DIE
}
