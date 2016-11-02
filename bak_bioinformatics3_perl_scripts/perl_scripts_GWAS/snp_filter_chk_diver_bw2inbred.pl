#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 4;
my ($jvcf,$inbred_name,$cut,$out) = @ARGV;

open IN,$inbred_name or die "$!";
my %inbred_name;
while(<IN>){
    chomp;
    my ($indi,$cau_acc,$name) = split;
    $inbred_name{$cau_acc} = $name;
}

open OUT,"+>$out" or die "$!";
open JVCF,$jvcf or die "$!";
my $header = <JVCF>;
chomp $header;
my ($head_chr,$head_pos,$head_alle,@inbred) = split(/\t/,$header);
my %inbred_cmp;
my $flag = 0;
while(<JVCF>){
    chomp;
    ++ $flag;
    next if $flag % $cut !=0;
    print "$flag have been Done!\n" if $flag % 10000 == 0;
    my ($chr,$pos,$alleles,@geno) = split;
    for(my $i = 0;$i < @inbred;++$i){
        for(my $j = $i +1;$j < @inbred;++$j){
            my ($geno1,$geno2) = ($geno[$i],$geno[$j]);
            my ($inbred1,$inbred2) = ($inbred[$i],$inbred[$j]);
            if($geno1 =~ /[ACGT]/ && $geno2 =~ /[ACGT]/){
                ${$inbred_cmp{"$inbred1\t$inbred2"}}[1] ++;
                if($geno1 eq $geno2){
                    ${$inbred_cmp{"$inbred1\t$inbred2"}}[0] ++;
                }
            }
        }
    }
}
close JVCF;

for(my $i = 0;$i < @inbred;++$i){
    for(my $j = $i +1;$j < @inbred;++$j){
        my ($inbred1,$inbred2) = ($inbred[$i],$inbred[$j]);
        my ($inbred_name1,$inbred_name2) = ($inbred_name{$inbred1}, $inbred_name{$inbred2});
        my ($eq_sites,$tot_sites)  = @{$inbred_cmp{"$inbred1\t$inbred2"}};
        print OUT "$inbred1\t$inbred_name1\t$inbred2\t$inbred_name2\t$eq_sites\t$tot_sites\n";
    }
}

sub usage{
    my $die =<<DIE;
    perl *.pl <jvcf> <inbred alias name> <escape n SNPs> <OUTPUT> 
DIE
}
