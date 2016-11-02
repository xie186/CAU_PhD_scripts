#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==4;
my ($ge_TE,$gff,$wth_TE,$wthout)=@ARGV;
open TE,$ge_TE or die "$!";
my %hash;
while(<TE>){
    chomp;
    $hash{$_}++;
}

open GFF,$gff or die "$!";
open WITH,"+>$wth_TE" or die "$!";
open WITHOUT,"+>$wthout" or die "$!";
while(<GFF>){
    chomp;
    my ($gene)=(split)[8];
    if(exists $hash{$gene}){
        print WITH "$_\n";
    }else{
        print WITHOUT "$_\n";
    }
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Genes with TE> <GFF with rpkm> <GFF (genes with TE)> <GFF (genes without TE)>
DIE
}
