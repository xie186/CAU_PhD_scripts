#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==3;
my ($snp,$map,$ped) = @ARGV;
open SNP,$snp or die "$!";
my $head = <SNP>;
chomp $head;
my ($tem_chr,$tem_pos,$tem_b73,@head) = split(/\s+/,$head); # delete the two row belong to chrom and pos
my $inbred_nu = @head;
my %hash_snp;
my $snp_nu = 0;
open MAP,"+>$map" or die "$!";
open PED,"+>$ped" or die "$!";
my $snp_wrong = 0;
my $snp_tot = 0;
while(<SNP>){
    chomp;
    ++ $snp_tot;
    next if !/^chr\d/;
    my ($chr,$pos,$b73_ref,@inbred) = split(/\s+/); # the third line is B73 reference
    print MAP "$chr\t$snp_nu\t$pos\n";
    ++ $snp_nu;
    if($inbred_nu != @inbred){
	++ $snp_wrong;
        next;
    }
    for(my $i= 0; $i< $inbred_nu; ++ $i){
         push @{$hash_snp{$head[$i]}},  "$inbred[$i] $inbred[$i]";
    }
}

my $flag = 1; 
foreach(@head){
    my $snp_infor = join("\t",@{$hash_snp{$_}});
       $snp_infor =~ s/[ATGC]\/[ATGC]/0/g;
       $snp_infor =~ tr/ACGTx/12340/;
    print PED "family$flag\t$_\t0\t0\t0\t0\t$snp_infor\n";
    ++ $flag;
}
close PED;

print <<REPORT;
=== $snp ===
Total number :$snp_tot;
Wrong number :$snp_wrong;
Percentage: $snp_tot/$snp_wrong;

REPORT

sub  usage{
    print <<DIE;
    perl *.pl <SNP> <OUT map> <OUT ped>
DIE
    exit 1;
}
