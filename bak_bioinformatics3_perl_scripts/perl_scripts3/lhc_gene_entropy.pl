#!/usr/bin/perl -w
use strict;
my ($cpg_oe,$entro)=@ARGV;
die usage() unless @ARGV==2;
open ENTRO,$entro or die "$!";
my %hash;
while(<ENTRO>){
    chomp;
    my ($gene,$entropy)=(split(/\t/,$_))[0,-1];
    $hash{$gene}=$entropy;
}

open OE,$cpg_oe or die "$!";
while(<OE>){
    chomp;
    my ($gene)=(split)[3];
    next if !exists $hash{$gene};
    print "$_\t$hash{$gene}\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <CpG O/E> <Gene entropy>
DIE
}
