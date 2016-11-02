#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==1;
my ($ped) = @ARGV;
open PED,$ped or die "$!";
my %hash_haplo;
my $inbred_nu;
while(<PED>){
    chomp;
    my ($fam,$inbred,$non1,$non2,$non3,$non4,@geno) = split(/\t/);
    my $haplo = join("\t",@geno);
    push @{$hash_haplo{$haplo}},$inbred;
    ++$inbred_nu;
}

foreach(keys %hash_haplo){
    my $nu = @{$hash_haplo{$_}};
    my $inbred_name  = join("-",@{$hash_haplo{$_}});
    my $freq = $nu/$inbred_nu;
    my $haplo = $_;
       $haplo =~s/1 1/A/g;
       $haplo =~s/2 2/C/g;
       $haplo =~s/3 3/G/g;
       $haplo =~s/4 4/T/g;
       $haplo =~ s/\t//g;
    print "$haplo\t$nu\t$inbred_nu\t$freq\t$inbred_name\n"
}

sub usage{
    my $die=<<DIE;
    perl *.pl <> 
DIE
}

