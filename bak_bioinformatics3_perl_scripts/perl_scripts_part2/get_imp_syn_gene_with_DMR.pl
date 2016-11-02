#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==2;
my ($imp_asso_dmr,$syn_imp) = @ARGV;
open ASSO,$imp_asso_dmr or die "$!";
my %hash_imp;
while(<ASSO>){
    chomp;
    $hash_imp{$_} ++;
}

open SYN,$syn_imp or die "$!";
while(<SYN>){
    chomp;
    my ($ge_zm,$ge_rice) = split;
    print "$_\n" if exists $hash_imp{$ge_zm};
}

sub usage{
    my $die =<<DIE;
    perl *.pl <imprinted genes associated with DMR> <Syntenic genes bw zm and rice>
DIE
}
