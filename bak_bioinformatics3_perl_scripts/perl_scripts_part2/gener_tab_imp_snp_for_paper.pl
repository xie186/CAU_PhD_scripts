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
    $hash_imp{$name[0]} = $name;
}

open LIS,$snp_list or die "$!";
while(<LIS>){
    chomp;
    #chr3    1296251 13      4       6       20       0.391172522810139       0.267257493154388      T/A     mat     NA      GRMZM5G860761   821     exon    324 941      +
    next if ($_ !~ /exon/ && $_ !~ /intron/);
    my @ele = split;
    my ($chr,$pos,$gene) = (split)[0,1,11];
    if(exists $hash_imp{$gene}){
        $ele[11] = $hash_imp{$gene};
        my $join = join("\t",@ele);
        print "$join\t$tis\n";
    }
}

sub usage{
    my $die =<<DIE;
    perl *.pl <imp> <SNP list>
DIE
}
