#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==3;
my ($hap,$map,$ped) = @ARGV;
open HAP,$hap or die "$!";
my $head = <HAP>;
chomp $head;
my @head = split(/\s+/,$head);
foreach(1..11){
    shift @head;
}
my $inbred_nu = @head;
my %hash_snp;
my $snp_nu = 1;
open MAP,"+>$map" or die "$!";
open PED,"+>$ped" or die "$!";
while(<HAP>){
    chomp;
#    rs      alleles chrom   pos     strand  assembly        center  protLSID        assayLSID       panel   QCcode
    my ($rs,$allel,$chr,$pos,$strand,$assembly,$center,$protLSID,$assayLSID,$panel,$QCcode,@inbred) = split;
    $chr =~s/chr//g; 
    print MAP "$chr\tchr$chr\_$pos\t$pos\n";
    ++ $snp_nu;
    print "xx:inbred ne head\n" if $inbred_nu != @inbred;
    for(my $i= 0; $i< @head; ++ $i){
         my ($geno) = split(//,$inbred[$i]);
         push @{$hash_snp{$head[$i]}},  "$geno $geno";
    }
}

my $flag = 1; 
foreach(sort keys %hash_snp){
    my $snp_infor = join("\t",@{$hash_snp{$_}});
       $snp_infor =~ tr/ACGTN/12340/;
    print PED "family$flag\t$_\t0\t0\t0\t0\t$snp_infor\n";
    ++ $flag;
}

sub  usage{
    print <<DIE;
    perl *.pl <HAPMAP file> <OUT map> <OUT ped>
DIE
    exit 1;
}
