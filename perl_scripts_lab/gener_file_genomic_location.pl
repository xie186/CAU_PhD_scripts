#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==2;
my ($gff_gene, $gff_te) = @ARGV;

open GFF, $gff_gene or die "$!";
my %gene_class;
my %gene_exon;
while(<GFF>){
    chomp;
    #chr1    TAIR10  gene    5928    8737    .       -       .       ID=AT1G01020;Note=protein_coding_gene;Name=AT1G01020
    my ($chr,$ver, $ele, $stt,$end, $dot1, $dot2, $dot3, $info)  = split;
    if(/Note=/){
        my ($gene_id, $gene_class) = $info =~ /ID=(.*);Note=(.*);Name=/;
        if($gene_class eq "protein_coding_gene"){
            $gene_class{$gene_id} = "protein_coding_gene";
        }else{
            if($gene_class eq "miRNA" || $gene_class eq "other_RNA" || $gene_class eq "rRNA" || $gene_class eq "snoRNA" || $gene_class eq "snRNA" || $gene_class eq "tRNA"){
                $gene_class{$gene_id} = "ncRNA";
            }elsif($gene_class eq "pseudogene"){
                $gene_class{$gene_id} = "pseudogene";
            }elsif($gene_class eq "transposable_element_gene"){
                $gene_class{$gene_id} = "TE";
            }
            print "$chr\t$stt\t$end\t$gene_class{$gene_id}\n";
         }
     }else{
         if($ele eq "CDS"){
             print "$chr\t$stt\t$end\tCDS\t\n";
         }elsif($ele =~ /UTR/){
             print "$chr\t$stt\t$end\tUTR\n";
         }elsif($ele =~ /exon/){
             my ($trans) = $info =~ /Parent=(.*)/;
             my ($gene_id) = split(/\./, $trans);
             push @{$gene_exon{"$trans\t$chr"}}, ($stt, $end) if $gene_class{$gene_id} eq "protein_coding_gene";
         }else{
             
         }
     }
}
close GFF;

foreach(keys %gene_exon){
    my @exon_pos = sort {$a<=>$b} @{$gene_exon{$_}};
    my ($trans, $chr) = split(/\t/, $_);
    for(my $i =1 ; $i < @exon_pos-1; $i +=2){
        my ($intron_stt, $intron_end) = ($exon_pos[$i] +1, $exon_pos[$i+1]-1);
        print "$chr\t$intron_stt\t$intron_end\tIntronic\n";
    }
}

open TE, $gff_te or die "$!";
while(<TE>){
    chomp; 
    next if /^Transposon_Name/;
    my ($id, $strand, $stt, $end) = split;
    my ($chr) = $id =~ /AT(\d+)TE/;
    print "chr$chr\t$stt\t$end\tTE\n";
}
close TE;

sub usage{
    my $die =<<DIE;
perl $0 <GFF gene> <gff TE> 
DIE
}

=pod
miRNA
other_RNA
protein_coding_gene
pseudogene
rRNA
snoRNA
snRNA
transposable_element_gene
tRNA
=end
