#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 7;

my ($vcf1,$vcf2,$alias,$inbred,$gatk_uniq,$sam_uniq,$both) = @ARGV;

open ALIAS,$alias or die "$!";
my ($tem_cau);
while(<ALIAS>){
    chomp;
    my ($fam,$cau_acc,$real) = split;
    $tem_cau = $cau_acc if $real eq $inbred;
}

open VCF1,$vcf1 or die "$!";
my $head = <VCF1>;
chomp $head;
my ($dot1,$dot2,$dot3,@cau_acc) = split(/\t/,$head);
my ($index1);
for(my $i = 0;$i < @cau_acc;++$i){
    $index1 = $i if $cau_acc[$i] eq $tem_cau;
}
my %snp_pos;
my %snp_pos1;
my %snp_pos2;
while(<VCF1>){
    chomp;
    my $nu = $_ =~ s/[A-Z]\/[A-Z]/x/g;
    next if $nu > 1; ### delete the hetero-SNPs
    my ($chr,$pos,$alle,@geno) = split;
    my $in_alle = $geno[$index1];
    next if $in_alle eq "x";
    $snp_pos1{"$chr\t$pos"} = $in_alle;
    $snp_pos{"$chr\t$pos"} ++;
}

open VCF2,$vcf2 or die "$!";
   $head = <VCF2>;
chomp $head;
   ($dot1,$dot2,$dot3,@cau_acc) = split(/\t/,$head);
my  ($index2);
for(my $i = 0;$i < @cau_acc;++$i){
    $index2 = $i if $cau_acc[$i] eq $tem_cau;
}

while(<VCF2>){
    chomp;
    my $nu = $_ =~ s/[A-Z]\/[A-Z]/x/g;
    next if $nu > 1; ### delete the hetero-SNPs
    my ($chr,$pos,$alle,@geno) = split;
    my $in_alle = $geno[$index2];
    next if $in_alle eq "x";
    $snp_pos2{"$chr\t$pos"} = $in_alle;
    $snp_pos{"$chr\t$pos"} ++;
}

open GATK,"+>$gatk_uniq" or die "$!";
open SAM,"+>$sam_uniq" or die "$!";
open BOTH,"+>$both" or die "$!";
foreach (keys %snp_pos){
    if(exists $snp_pos1{$_} && exists $snp_pos2{$_}){
        print BOTH "$_\t$snp_pos1{$_}\t$snp_pos2{$_}\n";
    }elsif(exists $snp_pos1{$_} && !exists $snp_pos2{$_}){
        print GATK "$_\t$snp_pos1{$_}\n";
    }elsif(!exists $snp_pos1{$_} && exists $snp_pos2{$_}){
        print SAM "$_\t$snp_pos2{$_}\n";
    }
}

sub usage{
    my $die =<<DIE;
    perl *.pl <vcf GATK> <vcf Samtools> <alias> <inbred> <gatk_uniq> <sam_uniq> <both>
DIE
}
