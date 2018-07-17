#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my ($func, $gff) = @ARGV;
open FUNC, $func or die "$!";
my %rec_func;
while(<FUNC>){
    chomp;
    my ($gene, $type, $descrip) = split(/\t/);
    $gene =~ s/\.\d+//g;
    $descrip = "NA" if !$descrip;
    $rec_func{$gene} = $descrip;
}
close FUNC;

open GFF, $gff or die "$!";
while(<GFF>){
    chomp;
    #chr1    TAIR10  gene    3631    5899    .       +       .       ID=AT1G01010;Note=protein_coding_gene;Name=AT1G01010
    my ($chr,$version,$ele, $stt,$end,$dot1,$strand, $dot2, $id) = split;
    next if ($ele !~ /gene/ || $chr !~ /^chr\d+/);
    my ($gene) = $_=~/ID=(AT\d+G\d+)/;
    $gene =~ s/\.\d+//g;
    print "$chr\t$stt\t$end\t$gene\t$strand\t$rec_func{$gene}\n";
}
close GFF;

sub usage{
    my $die =<<DIE;
perl *.pl <func> <gff> 
DIE
}
