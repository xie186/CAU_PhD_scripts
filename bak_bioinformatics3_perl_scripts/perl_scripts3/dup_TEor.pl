#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==1;
my ($rpkm)=@ARGV;
open RPKM,$rpkm or die "$!";
while(<RPKM>){
    chomp;
    my ($gene1,$rpkm1,$gene2,$rpkm2,$te1,$te2)=split;
    next if ($te1 eq $te2);
    if($te1 eq "TE"){
        print "$gene1\t$rpkm1\t$gene2\t$rpkm2\t$te1\t$te2\n";
    }else{
        print "$gene2\t$rpkm2\t$gene1\t$rpkm1\t$te2\t$te1\n";
    }
}


sub usage{
    my $die=<<DIE;
    perl *.pl <Dup RPKM>
DIE
}
