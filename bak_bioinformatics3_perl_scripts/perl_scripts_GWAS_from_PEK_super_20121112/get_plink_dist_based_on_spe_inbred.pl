#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==4;
my ($ped,$dist,$inbred1,$alias) = @ARGV;

open DIS,$dist or die "$!";
my $row = 0;
my %hash;
while(<DIS>){
    chomp;
    my @dis = split;
    for(my $i = 0;$i<@dis;++$i){
        $hash{"$row\t$i"} = $dis[$i];
    }
    ++$row;
}

open ALIAS,$alias or die "$!";
my %inbred_real;
while(<ALIAS>){
     chomp;
     my ($fam,$cau,$name) = split;
     $inbred_real{$cau} = $name;
}

open PED,$ped or die "$!";
my @inbred;
while(<PED>){
    chomp;
    my ($fam,$inbred) = split(/\t/);
    push @inbred ,$inbred;
}

for(my $i = 0;$i< @inbred; ++$i){
    if($inbred[$i] eq $inbred1){
        for(my $j = 0;$j < @inbred;++$j){
            print "$inbred_real{$inbred[$j]}\t$hash{\"$i\t$j\"}\n";
        }
    }
}

sub usage{
    my $die =<<DIE;
    perl *.pl <ped> <dist> <inbred1> <inbred alias name>
DIE
}
