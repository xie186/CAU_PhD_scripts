#!/usr/bin/perl -w
use strict;
my ($clus) = @ARGV;
die usage() unless @ARGV==1;
open CLUS,$clus or die "$!";
my %sm_uniq;
my %sm_nu;
my ($sm_uniq_tot,$sm_nu_tot) = (0,0);
while(<CLUS>){
     chomp;
     my ($chr,$stt,$end,$reads) =split;
     my @tem = split(/;/,$reads);
     
     foreach my $stem (@tem){
         my ($id,$len,$nu) = split(/_/,$stem);
         $sm_nu{$len} += $nu;
         $sm_uniq{$len} ++;
         $sm_nu_tot += $nu;
         $sm_uniq_tot ++;
     }
}

foreach(keys %sm_nu){
    print "$_\t$sm_uniq{$_}\t$sm_uniq_tot\t$sm_nu{$_}\t$sm_nu_tot\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <CLUS>
    We use this scripts to get the length distribution of smRNA located in the cluster
DIE
}
