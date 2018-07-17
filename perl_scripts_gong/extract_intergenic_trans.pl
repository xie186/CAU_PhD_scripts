#!/usr/bin/perl -w
use strict;

my ($gtf) = @ARGV;
open GTF, $gtf or die "$!";
my %gene_pos;
my %gene_chr;
my %gene_strand;
while(<GTF>){
    chomp;
    #chr1    Cufflinks       exon    6744    7228    .       +       .       gene_id "XLOC_000002"; transcript_id "TCONS_00000002"; exon_number "1"; gene_name "AT1G01020"; oId "CUFF.2.1"; nearest_ref "AT1G01020.1"; class_code "s"; tss_id "TSS2";
    my ($chr,$tool, $ele, $stt,$end,$dot1,$strand,$dot2,$attri) =split(/\t/);
    my ($gene_id) = $attri =~ /gene_id "(.*)"; transcript_id/;
    my ($gene_name) = $attri =~ /gene_name "(.*)";/;
    my ($class_code) = $attri =~ /class_code "(.*)"; /;
    next if $class_code ne "u";
    push @{$gene_pos{$gene_id}}, ($stt, $end);
    $gene_chr{$gene_id} = $chr;
    $gene_strand{$gene_id} = $strand;
    
}

foreach(keys %gene_pos){
    my ($stt, $end) = sort{$a<=>$b} @{$gene_pos{$_}};
    print "$gene_chr{$_}\t$stt\t$end\t$_\t$gene_strand{$_}\n";
}
