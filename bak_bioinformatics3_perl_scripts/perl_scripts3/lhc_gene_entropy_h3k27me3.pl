#!/usr/bin/perl -w
use strict;
my ($cpg_oe,$entro)=@ARGV;
die usage() unless @ARGV==2;
open ENTRO,$entro or die "$!";
my %hash;
while(<ENTRO>){
    chomp;
    my ($gene)=(split(/\t/,$_))[3];
    $hash{$gene}=$_;
}

open OE,$cpg_oe or die "$!";
while(<OE>){
    chomp;
    my ($gene)=(split)[3];
    next if !exists $hash{$gene};
    print "$hash{$gene}\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <CpG O/E> <Gene entropy>
DIE
}
