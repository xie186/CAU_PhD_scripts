#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 3;
my ($anno,$deg, $index) = @ARGV;
open ANNO,$anno or die "$!";
my %gene_anno;
while(<ANNO>){
    chomp;
    my ($gene,$annotation) = split(/\t/, $_, 2);
    $gene_anno{"$gene"} = $annotation;
}
close ANNO;


open GENE,$deg or die "$!";
while(<GENE>){
    chomp;
    next if !/^AT/;
    my @tem = split(/\t/);
    if(exists $gene_anno{$tem[$index-1]}){
        print "$tem[$index-1]\t$gene_anno{$tem[$index-1]}\n";
    }else{
        print "$tem[$index-1]\n";
    }
}
close GENE;

sub usage{
    my $die =<<DIE;
    perl *.pl <anno> <DEG> <gene column>
DIE
}

