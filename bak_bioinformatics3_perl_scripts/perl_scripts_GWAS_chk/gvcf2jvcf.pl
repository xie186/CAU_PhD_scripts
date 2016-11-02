#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my ($vcf,$fil,$heter) = @ARGV;
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
        next if ($filter ne "PASS" || $qual < $fil);
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

sub maf{
    my ($snp_infor) = @_;
    my $tot_1 = $snp_infor =~ s/[XU]/0/g;
    my $tot_2 = $snp_infor =~ tr/ACGTx/12340/;
    my $tot = $tot_1 + $tot_2;
    my $mis = $snp_infor =~ tr/0/0/ || 0;
    my %base_nu;
       $base_nu{"A"} = $snp_infor =~ s/1/1/g || 0;
       $base_nu{"C"} = $snp_infor =~ s/2/2/g || 0;
       $base_nu{"G"} = $snp_infor =~ s/3/3/g || 0;
       $base_nu{"T"} = $snp_infor =~ s/4/4/g || 0;
    my ($max,$min,$third_alle) = sort{$b<=>$a} values %base_nu;
    my $mis_rate = $mis / $tot;
    my $maf = 0;
       $maf = $min / ($tot -  $mis) if $tot -  $mis != 0;
    return ($mis_rate,$maf,$third_alle);
}

sub usage{
    my $die =<<DIE;
    perl *.pl <VCF> <filter>
DIE
}
