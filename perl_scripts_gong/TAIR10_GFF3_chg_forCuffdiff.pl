#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 1;
my ($gff) = @ARGV;
open GFF,$gff or die "$!";
while(<GFF>){
    chomp;
    #chr1    TAIR10  gene    3631    5899    .       +       .       ID=AT1G01010;Note=protein_coding_gene;Name=AT1G01010
    #chr1    TAIR10  mRNA    3631    5899    .       +       .       ID=AT1G01010.1;Parent=AT1G01010;Name=AT1G01010.1;Index=1
    #chr1    TAIR10  exon    3631    3913    .       +       .       Parent=AT1G01010.1
    my ($chr,$tool,$ele, $stt,$end, $dot1, $strand, $dot2, $attri) = split;
    #next if ($ele !~ /mRNA/ || $ele ~= /exon/);
    if($ele =~ /mRNA/){
        $_ =~ s/Parent/gene_name/g;
        print "$_\n";
    }elsif($ele =~ /exon/){
        print "$_\n";
    }
}

sub usage{
    my $die =<<DIE;
    perl *.pl <gff>  > gff_forCuffdiff
DIE
}
