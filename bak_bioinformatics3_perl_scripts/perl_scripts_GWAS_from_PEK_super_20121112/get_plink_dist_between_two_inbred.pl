#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==4;
my ($ped,$dist,$inbred1,$inbred2) = @ARGV;

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

open PED,$ped or die "$!";
my @inbred;
my $in = 0;
my ($tem_row,$tem_col) ;
while(<PED>){
    chomp;
    my ($fam,$inbred) = split(/\t/);
    $tem_row = $in if $inbred eq $inbred1;
    $tem_col = $in if $inbred eq $inbred2;
    ++$in;
}

print "$inbred1\t$inbred2\t$hash{\"$tem_row\t$tem_col\"}\n";

sub usage{
    my $die =<<DIE;
    perl *.pl <ped> <dist> <inbred1> <inbred2> 
DIE
}
