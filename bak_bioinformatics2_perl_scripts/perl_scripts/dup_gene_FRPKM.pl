#!/usr/bin/perl -w
use strict;
my ($rpkm,$dup)=@ARGV;
die usage() unless @ARGV==2;
open RPKM,$rpkm or die "$!";
my %hash;
while(<RPKM>){
    chomp;
    my ($gene,$rpkm)=(split)[0,-4];
    $hash{$gene}=$rpkm;
}

open DUP,$dup or die "$!";
my ($tot1,$tot2)=(0,0);
while(<DUP>){
    next if (/^#/ || /^\n/);
    chomp;
    my ($id_dup,$id_ge,$gene1,$gene2,$evalue)=split;
    my ($rpkm1,$rpkm2)=(0,0);
    $rpkm1=$hash{$gene1} if exists  $hash{$gene1};
    $rpkm2=$hash{$gene2} if exists  $hash{$gene2};
    print "$id_dup\t$id_ge\t$gene1\t$rpkm1\t$gene2\t$rpkm2\t$evalue\n";
    $tot1+=$rpkm1;
    $tot2+=$rpkm2;
}
#print "$tot1\t$tot2\n";
sub usage{
    my $die=<<DIE;
    perl *.pl <FPKM WGS> <Duplicated genes alingns>
DIE
}
