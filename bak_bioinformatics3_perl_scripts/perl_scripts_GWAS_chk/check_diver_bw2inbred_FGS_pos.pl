#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 6;

my ($vcf,$geno_len,$chrom,$alias,$inbred1,$inbred2) = @ARGV;
my $BIN = 5000000;
open ALIAS,$alias or die "$!";
my ($tem_cau1,$tem_cau2);
while(<ALIAS>){
    chomp;
    my ($fam,$cau_acc,$real) = split;
    $tem_cau1 = $cau_acc if $real eq $inbred1;
    $tem_cau2 = $cau_acc if $real eq $inbred2;
}

print "chr\tpos\talleles\t$inbred1\t$inbred2\n";
open VCF,$vcf or die "$!";
my $head = <VCF>;
my ($dot1,$dot2,$dot3,@cau_acc) = split(/\t/,$head);
my ($index1,$index2);
for(my $i = 0;$i < @cau_acc;++$i){
    $index1 = $i if $cau_acc[$i] eq $tem_cau1;
    $index2 = $i if $cau_acc[$i] eq $tem_cau2;
}

my %diver;
while(<VCF>){
    chomp;
    my ($chr,$pos,$alle,@geno) = split;
    my $tem_geno = join("\t",@geno);
       $tem_geno =~ s/[A-Z]\/[A-Z]/x/g;
       @geno = split(/\t/,$tem_geno);
    my ($in_alle1,$in_alle2) = ($geno[$index1],$geno[$index2]);
    if ($in_alle1 ne "x" && $in_alle2 ne "x"){
        if($in_alle1 ne $in_alle2){
            print "$chr\t$pos\t$alle\t$in_alle1\t$in_alle2\n";
        }
    }
}

sub usage{
    my $die =<<DIE;
    perl *.pl <vcf> <geno_len> <chrom> <alias> <inbred> <inbred2>
DIE
}
