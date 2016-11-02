#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my ($imp,$snp_list) = @ARGV;
my ($tis) = $snp_list =~ /_(\d+DAP)/;
open IMP,$imp or die "$!";
my %hash_imp;
while(<IMP>){
    chomp;
    my ($name) = split;
    my @name = split(/\//,$name);
    foreach my $tem_name(@name){
        $hash_imp{$tem_name} ++;
    }
#    $hash_imp{$name[0]} = $name;
}

open LIS,$snp_list or die "$!";
my $header = <LIS>;
my %hash_gene;
print "$header";
while(<LIS>){
    chomp;
    # chr1    3040300 GRMZM5G881380   C/T     3       10      11      1       0.0009  1.81E-05        pat     10DAP
    my ($chr,$pos,$gene) = (split);
    $hash_gene{$gene} ++;
    if(exists $hash_imp{$gene}){
        print "$_\n";
    }else{
#        print "$_\n";
    }
}

foreach(keys %hash_imp){
    if(!exists $hash_gene{$_}){
        print "xx\t$_\n";
    }
}

sub usage{
    my $die =<<DIE;
    perl *.pl <imp> <SNP list>
DIE
}
