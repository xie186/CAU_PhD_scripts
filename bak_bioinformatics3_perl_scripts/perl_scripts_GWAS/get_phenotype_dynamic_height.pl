#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 7;
my ($pheno,$inbred,$pheno1,$pheno2,$pheno3,$pheno4,$pheno5) =  @ARGV; 
my %hash_in_name;
open PHE,$pheno or die "$!";
my $header = <PHE>;
my ($inred_line,@phe_name) = split(/\s+/,$header);
open PHE1,"+>$pheno1" or die "$!";
open PHE2,"+>$pheno2" or die "$!";
open PHE3,"+>$pheno3" or die "$!";
open PHE4,"+>$pheno4" or die "$!";
open PHE5,"+>$pheno5" or die "$!";
print PHE1 "Taxa\t$phe_name[0]\n";
print PHE2 "Taxa\t$phe_name[1]\n";
print PHE3 "Taxa\t$phe_name[2]\n";
print PHE4 "Taxa\t$phe_name[3]\n";
print PHE5 "Taxa\t$phe_name[4]\n";
while(<PHE>){
    chomp;
    my ($name,$phe1,$phe2,$phe3,$phe4,$phe5) = split;
    ${$hash_in_name{$name}}[0] = $phe1;
    ${$hash_in_name{$name}}[1] = $phe2;
    ${$hash_in_name{$name}}[2] = $phe3;
    ${$hash_in_name{$name}}[3] = $phe4;
    ${$hash_in_name{$name}}[4] = $phe5;
}
close PHE;

open IN,$inbred or die "$!";
while(<IN>){
    chomp;
    my ($name) = split(/\s+/,$_);
    if(exists $hash_in_name{$name}){
        print PHE1 "$name\t${$hash_in_name{$name}}[0]\n";
        print PHE2 "$name\t${$hash_in_name{$name}}[1]\n";
        print PHE3 "$name\t${$hash_in_name{$name}}[2]\n";
        print PHE4 "$name\t${$hash_in_name{$name}}[3]\n";
        print PHE5 "$name\t${$hash_in_name{$name}}[4]\n";
    }else{
        print PHE1 "$name\tNaN\n";
        print PHE2 "$name\tNaN\n";
        print PHE3 "$name\tNaN\n";
        print PHE4 "$name\tNaN\n";
        print PHE5 "$name\tNaN\n";
    }
}

sub usage{
    print <<DIE;
    perl *.pl <Phenotype> <pca results>  <Pheno1>  <Pheno2> <Pheno3> <Pheno4> <Pheno5>
DIE
   exit 1;
}
