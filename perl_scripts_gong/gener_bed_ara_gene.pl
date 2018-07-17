#!/usr/bin/perl -w
use strict;

my ($gff) = @ARGV;
open GFF,$gff or die "$!";
while(<GFF>){
    chomp;
#    Chr1    TAIR10  gene    3631    5899    .       +       .       ID=AT1G01010;Note=protein_coding_gene;Name=AT1G01010
    my ($chr,$tool,$ele,$stt,$end,$dot1,$strand,$dot2,$name) = split;
    $chr =~ s/Chr/chr/g;
    next if ($ele !~ /gene/ || $ele =~ /mRNA/);
    my ($id, $type) = $name =~ /ID=(.*);Note=(.*)/;
    print "$chr\t$stt\t$end\t$id\t$strand\t$type\n";
}
