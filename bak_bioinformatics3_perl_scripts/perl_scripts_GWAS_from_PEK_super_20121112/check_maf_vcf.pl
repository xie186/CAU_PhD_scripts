#!/usr/bin/perl -w
use strict;

my ($vcf) = @ARGV;

open VCF,$vcf or die "$!";
<VCF>;
while(<VCF>){
    chomp;
    my ($chr,$pos,$ref,@geno) = split;
    my $snp_infor = join("\t",@geno);
    my ($mis_rate,$maf) = &maf($snp_infor); 
    my $bin = sprintf "%0.2f", $maf;
    print "$maf\t$bin\n";
}

sub maf{
    my ($snp_infor) = @_;
    my $tot_1 = $snp_infor =~ s/[ATGC]\/[ATGC]/0/g;
    my $tot_2 = $snp_infor =~ tr/ACGTx/12340/;
    my $tot = $tot_1 + $tot_2;
    my $mis = $snp_infor =~ tr/0/0/ || 0;
    my @base_nu;
       $base_nu[0] = $snp_infor =~ s/1/1/g || 0;
       $base_nu[1] = $snp_infor =~ s/2/2/g || 0;
       $base_nu[2] = $snp_infor =~ s/3/3/g || 0;
       $base_nu[3] = $snp_infor =~ s/4/4/g || 0;
    my ($max,$min) = sort{$b<=>$a} @base_nu;
    my $mis_rate = $mis / $tot;
    my $maf = 0;
       $maf = $min / ($tot -  $mis) if $tot -  $mis != 0;
#    print "$line\t$mis_rate, $maf\t$max,$min\n";
    return ($mis_rate,$maf);
}

