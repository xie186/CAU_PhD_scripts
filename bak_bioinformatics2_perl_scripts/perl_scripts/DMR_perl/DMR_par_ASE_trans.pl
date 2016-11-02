#!/usr/bin/perl -w
use strict;
my ($snp)=@ARGV;
open SNP,$snp or die "$!";
my %hash;
while(<SNP>){
    chomp;
    my ($gene,$b73,$mo17,$p1,$p2)=(split)[0,2,3,-2,-1];
#    next if ($p1>=0.01);
    if($b73>2*$mo17){
        push @{$hash{$gene}},"mat";
    }elsif($b73<2*$mo17){
        push @{$hash{$gene}},"pat";
    }else{
 
    }
}

foreach(keys %hash){
    my ($mat,$pat)=(0,0);
    next if @{$hash{$_}}<2;
    foreach my $ase(@{$hash{$_}}){
        if($ase eq "mat"){
            $mat++;
        }elsif($ase eq "pat"){
            $pat++;
        }
    }
    if($mat==0 && $pat>0){
        print "$_\tpse\n";
    }elsif($mat>0 && $pat==0){
        print "$_\tmse\n";
    }else{

    }
}
