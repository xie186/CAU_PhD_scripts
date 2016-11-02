#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==2;
my ($imp,$asso_gene,$cutoff)=@ARGV;
open IMP,$imp or die "$!";
my %hash;
while(<IMP>){
    chomp;
    $hash{$_}++;
}

open ASSO,$asso_gene or die "$!";
while(<ASSO>){
    chomp;
    my ($gene,$b73,$mo17)=(split)[3,7,8];
#    my ($min,$mid,$max)=sort{$a<=>$b}@meth;
    print "$_\n" if(exists $hash{$gene});
}
sub usage{
    my $die=<<DIE;
    perl *.pl <IMP> <Asso_gene> 
DIE
}
