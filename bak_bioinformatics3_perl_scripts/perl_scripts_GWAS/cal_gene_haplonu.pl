#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==2;
my ($ped,$freq_cut) =@ARGV;
open PED,$ped or die "$!";
my %hash_haplo;
my $inbred_nu;
while(<PED>){
    chomp;
    my ($gene,$inbred,@geno) = split(/\t/);
    my $geno = join("",@geno);
    $hash_haplo{$gene}->{$geno} ++;
    $inbred_nu++;
}

my %haplo_nu;
foreach my $gene(keys %hash_haplo){
    foreach my $haplo(keys %{$hash_haplo{$gene}}){
        my $freq =  $hash_haplo{$gene}->{$haplo}/$inbred_nu;
        $haplo_nu{$gene} ++ if $freq >= $freq_cut;
    }
}

foreach(keys %haplo_nu){
    print "$_\t$haplo_nu{$_}\n";
}


sub usage{
    my $die =<<DIE;
    perl *.pl <ped file> <freq cutoff> 
DIE
}
