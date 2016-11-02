#!/usr/bin/perl -w
use strict;
my ($anno,$snpEff) = @ARGV;
die usage() unless @ARGV == 2;
open ANNO,$anno or die "$!";
my %anno;
while(<ANNO>){
    chomp;
    my ($gene,$annotation) = split(/\t/);
       $gene =~ s/FGP/FG/;
    ($gene) = split(/_/,$gene) if $gene =~ /GRMZM/;
    $anno{$gene} = $annotation;
}
open EFF,$snpEff or die "$!";
my %hash_gene;
while(<EFF>){
    chomp;
    my ($chrom,$pos,$id,$ref,$alt,$qual,$filter,$type,$order,$effect,$amino_acid,$chg_pos,$gene,$trans,$intron_num) = split(/\t/);
    next if $type ne "STOP_GAINED";
    print "$chrom\t$pos\t$ref\t$alt\t$type\t$order\t$effect\t$amino_acid\t$chg_pos\t$gene\t$anno{$gene}\n";
}

sub usage{
    my $die =<<DIE;
    perl *.pl <annotation> <snpEff>
DIE
}
