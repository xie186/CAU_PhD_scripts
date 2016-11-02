#!/usr/bin/perl -w
use strict;
my ($sm_fa)=@ARGV;
die usage() unless @ARGV==1;
open FA,$sm_fa or die "$!";
my %hash;
while(<FA>){
    chomp;
    my @aa=split(//);
    for(my $i=0;$i<@aa;++$i){
        ${$hash{$i}}[0]++ if $aa[$i] eq "A";
        ${$hash{$i}}[1]++ if $aa[$i] eq "U";
        ${$hash{$i}}[2]++ if $aa[$i] eq "G";
        ${$hash{$i}}[3]++ if $aa[$i] eq "C";
    }
}
close FA;
print "A\tU\tG\tC\n";
foreach(sort{$a<=>$b} keys %hash){
    print "${$hash{$_}}[0]\t${$hash{$_}}[1]\t${$hash{$_}}[2]\t${$hash{$_}}[3]\n";
}
sub usage{
    my $die=<<DIE;
    perl *.pl  <Fasta> 
DIE
}
