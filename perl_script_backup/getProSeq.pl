#!/usr/bin/perl -w
use strict;
my $die=<<EOF;
perl *.pl <Pfam><ProteinSEQ>
EOF
die "$die" unless @ARGV==2;
open FAM,$ARGV[0] or die;
my %hash;
while(<FAM>){
    chomp;
    my @aa=split;
    $hash{">".$aa[0]}=0;
    #my @bb=keys %hash;
    #print "@bb\n";
}
close FAM;

open SEQ,$ARGV[1]or die;
while(my $nm=<SEQ>){
    chomp $nm;
    my ($name)=split(/\s+/,$nm);
    my $seq=<SEQ>;
    if (exists $hash{$name}){
        print "$nm\n$seq";
    }
}
close SEQ;
