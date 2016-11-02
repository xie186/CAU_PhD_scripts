#!/usr/bin/perl -w
use strict;
die "usage:perl *.pl <SNP> <GENE> <Intragenic> <Intergenic>" unless @ARGV==4;

open SNP,$ARGV[0] or die;
my %snp;
while(<SNP>){
    chomp;
    my ($chr,$pos)=(split)[0,1];
    $snp{"$chr\t$pos"}=$_;
}

open OUT1,"+>$ARGV[2]";
open OUT2,"+>$ARGV[3]";
open GEN,$ARGV[1] or die;

while(my $line=<GEN>){
    chomp $line;
    my ($ge_chr,$pos1,$pos2)=split(/\s+/,$line);
        $ge_chr="chr".$ge_chr;
    for($pos1..$pos2){
        if(exists $snp{"$ge_chr\t$_"}){
            print OUT1 "$snp{\"$ge_chr\t$_\"}\n";
            delete $snp{"$ge_chr\t$_"};
        }
    }
    
}

foreach(sort keys %snp){
    print OUT2 "$snp{$_}\n";
}

close SNP or die;
close GEN or die;
close OUT1 or die;
close OUT2 or die; 
