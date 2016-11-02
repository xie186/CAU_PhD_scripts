#!/usr/bin/perl -w
use strict;

my ($gene) = @ARGV;

open GENE,$gene or die "$!";
while(<GENE>){
    chomp;
    my ($chr,$stt,$end,$gene,$strand,$anno) = split;
    open ANNO,"$gene.var.flt.anno"  or die "$!";
    while (my $line = <ANNO>){
        next if $line =~ /^#/;
        #6_142867604_G/A 6:142867604     A       GRMZM5G869840   GRMZM5G869840_T01       Transcript      upstream_gene_variant
        my ($geno,$pos,$alt,$gene_id,$trans_id,$trans,$type)  = split(/\t/,$line);
        print "$gene_id\t$geno\t$type\t$anno\n" if $gene_id eq $gene;
    }
}

sub usage{
    my $die =<<DIE;
    perl *.pl <gene> 
DIE
}
