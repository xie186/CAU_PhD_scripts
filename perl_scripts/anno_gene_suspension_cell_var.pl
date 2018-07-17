#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my ($anno,$deg) = @ARGV;
open ANNO,$anno or die "$!";
my %gene_anno;
while(<ANNO>){
    chomp;
    #Model_name      Type    Short_description       Curator_summary Computational_description
    my ($gene, $type, $short_des) = split(/\t/, $_);
    $gene_anno{"$gene"} = $short_des;
}
close ANNO;
#chr1    1293802 .       A       +AT     100.0   3_prime_UTR_variant     MODIFIER        AT1G04645       AT1G04645.1     ddc-150uMs
print "#chr\tpos\tref\talt\tqual\teffect\timpact\tgene_name\tid\tsample\tannotation\n";
open GENE,$deg or die "$!";
while(<GENE>){
    chomp;
    next if /#/ || /MODIFIER/;
    my ($chr, $pos, $dot, $ref, $alt, $qual, $effect, $impact, $gene_name, $id, $sample) = split;
    if($id eq "-"){
        print "$_\tNA\n"; 
    }else{
        print "$_\t$gene_anno{$id}\n"; 
    }
}
close GENE;

sub usage{
    my $die =<<DIE;
    perl *.pl <anno> <DEG>
DIE
}

=pod
5_prime_UTR_premature_start_codon_gain_variant  LOW
disruptive_inframe_insertion    MODERATE
frameshift_variant      HIGH
missense_variant        MODERATE
splice_acceptor_variant HIGH
splice_donor_variant    HIGH
splice_region_variant   LOW
stop_gained     HIGH
stop_lost       HIGH
synonymous_variant      LOW
=doc
