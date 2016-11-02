#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==2;
my ($snp1,$snp2) = @ARGV;

my %hash_snp;
open SNP1,$snp1 or die "$!";
while(<SNP1>){
     my ($chr,$pos,$ref,$depth,$alle1,$alle1_nu,$alle2,$allle2_nu) = split;
     $hash_snp{"$chr\t$pos"} = "$chr\t$pos\t$alle1\t$alle2"
}

open SNP2,$snp2 or die "$!";
## chr1    15      .       A       G  
while(<SNP2>){
    chomp;
    my ($chr,$pos,$pot,$alle1,$alle2) = split;
    $hash_snp{"$chr\t$pos"} = "$chr\t$pos\t$alle1\t$alle2";
#    print "$chr\t$pos\t$pot\t$alle1\t$alle2\t xxx \t$chr\t$pos\t.\t$alle1\t$alle2 \n" if exists $hash_snp{"$chr\t$pos"};
}

foreach(keys %hash_snp){
    print "$hash_snp{$_}\n";
}
sub usage{
    print <<DIE;
    perl *.pl <snp from RNA-seq> <snp from Ren Longhui resequecing >
DIE
    exit 1;
}

