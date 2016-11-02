#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 5;
my ($snp_infor,$cut,$geno_len,$chrom,$out) = @ARGV;
my $BIN = 1000000;

open SNP,$snp_infor or die "$!";
my %hash_snp_bad;
my %hash_snp_good;
while(<SNP>){
    chomp;
    #chr1 12267 T C T        75      C       74      T       1       0
    my ($chr,$pos,$ref,$alt,$ref1,$dep,$ref2,$ref_dep,$alt1,$alt_dep,$contig) = split;
    next if ($dep =~ /NA/ || $dep == 0 ||$ref1 =~ /N/ || $ref2 ne $alt);
    if($ref_dep/$dep <=1 - $cut){
        print "bad\t$_\n";
        $hash_snp_bad{"$chr\t$pos"} ++;
    }
    if($ref_dep/$dep >=  $cut){
        print "good\t$_\n";
        $hash_snp_good{"$chr\t$pos"} ++;
    }
}

open LEN,$geno_len or die "$!";
my %hash_len;
while(<LEN>){
    chomp;
    my ($chr,$len) = split;
    $hash_len{$chr} = $len;
}

open OUT,"+>$out" or die "$!";
for(my $i=0;$i < $hash_len{$chrom}/$BIN;++$i){
    my ($tot_bad,$tot_good) = (0,0);
    foreach(keys %hash_snp_bad){
        my ($chr,$pos) = split(/\t/,$_);
        ++ $tot_bad if ($pos >=$i*$BIN && $pos < ($i+1)*$BIN);
    }
    foreach(keys %hash_snp_good){
        my ($chr,$pos) = split(/\t/,$_);
        ++ $tot_good if ($pos >=$i*$BIN && $pos < ($i+1)*$BIN);
    }
    my ($stt,$end) = ($i*$BIN, ($i+1)*$BIN);
    print OUT "$stt\t$end\t$tot_bad\t$tot_good\n";
}
close OUT;

sub usage{
    my $die =<<DIE;
    perl *.pl <SNP infor>  <cut off 0.9> <geno len> <chrom> <OUT>
DIE
}
