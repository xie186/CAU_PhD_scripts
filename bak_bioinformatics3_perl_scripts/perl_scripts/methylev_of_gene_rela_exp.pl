#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==2;
my ($exp,$meth_ele)=@ARGV;

open EXP,$exp or die "$!";
my %hash;
while(<EXP>){
    chomp;
    my ($name,$lev)=(split)[0,-2];
    $hash{$name}=$lev;
}

open METH,$meth_ele or die "$!";
while(my $meth=<METH>){
    chomp $meth; 
    my $report=0;
    foreach my $name (keys %hash){
        if($meth=~/^$name/){
           # my @tem=split(/\s+/,$meth);
            print "$meth\t$hash{$name}\n";
            $report++;
        }
    }
#    print "$meth\t0\n" if $report==0;
}



sub usage{
    my $die=<<DIE;
    
    perl *.pl <EXP RPKM> <Methylation information of  each element> >output

DIE
}
