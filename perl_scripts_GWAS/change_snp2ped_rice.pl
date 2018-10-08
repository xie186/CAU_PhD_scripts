#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==3;
my ($snp,$map,$ped) = @ARGV;
open SNP,$snp or die "$!";
my $head = <SNP>;
chomp $head;
my @head = split(/\s+/,$head);
foreach(1..8){
    shift @head;
}
my $inbred_nu = @head;
my %hash_snp;
my $snp_nu = 0;
open MAP,"+>$map" or die "$!";
open PED,"+>$ped" or die "$!";
while(<SNP>){
    chomp;
    my ($chr,$pos,$RefBase,$SnpBase,$TotalHitNum,$MAF,$RefNum,$SnpNum,@inbred) = split;
#    print MAP "$chr\t$snp_nu\t$pos\n";
    print MAP "$chr\t$chr\_$pos\t$pos\n";
    ++ $snp_nu;
    print "xx:inbred ne head\n" if $inbred_nu != @inbred;
    for(my $i= 0; $i< @head; ++ $i){
         push @{$hash_snp{$head[$i]}},  "$inbred[$i]\t$inbred[$i]";
    }
}

my $flag = 1; 
foreach(sort keys %hash_snp){
    my $snp_infor = join("\t",@{$hash_snp{$_}});
       $snp_infor =~ tr/ACGT-/12340/;
    print PED "family$flag\t$_\t0\t0\t0\t0\t$snp_infor\n";
    ++ $flag;
}

sub  usage{
    print <<DIE;
    perl *.pl <SNP> <OUT map> <OUT ped>
DIE
    exit 1;
}
