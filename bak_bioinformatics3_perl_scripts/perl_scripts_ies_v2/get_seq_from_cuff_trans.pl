#!/usr/bin/perl -w
use strict;
my ($geno,$imp,$gtf)=@ARGV;
die usage() unless @ARGV == 3;
open GENO,$geno or die "$!";
my @aa=<GENO>;
my $join=join('',@aa);
$join=~s/>//;                ##Delete the first ">"
   @aa=split(/>/,$join);
$join=@aa; #chromosome number
my %hash;
for(my $i=1;$i<=$join;++$i){
    my $tem=shift @aa;
    my ($chr,@seq)=split(/\n/,$tem);
    chomp @seq;
    my $tem_seq=join('',@seq);
    $hash{$chr}=$tem_seq;
}

open CUFF,$imp or die "$!";
#chr10   9532020 G/A     2       28      67      1       3.139e-12       2.2e-16 pat     pat     XLOC_009664_chr10_9530469_9533013_-     GRMZM2G324131|GRMZM2
my %hash_trans;
while(<CUFF>){
    chomp;
    my ($chr,$pos,$alt,$bm_b,$bm_m,$mb_b,$mb_m,$p1,$p2,$imp2to1,$imp5to1,$cuff_id,$gene,$class_code) = split;
    my ($cuff_trans) = $cuff_id =~ /(.*)_chr/;
    $hash_trans{$cuff_trans} = "$cuff_id:$gene:$class_code";
}
#chr0    Cufflinks       exon    3373088 3374452 .       -       .       gene_id "XLOC_000008"; transcript_id "en_10_12DAP_g_WGS_00000280"; exon_number "1";
open GTF,$gtf or die "$!";
my %hash_seq;
while(<GTF>){
    chomp;
    my ($chr,$tool,$ele,$stt,$end,$dot1,$strand,$dot2,$id) = split(/\t/);
    my ($gene_id,$trans_id) = $id =~ /gene_id "(.*)"; transcript_id "(.*)"; exon_number/;
    if(exists $hash_trans{$gene_id}){
        my $seq = substr($hash{$chr},$stt-1,$end-$stt+1);
        if($strand eq "-"){
            $seq =~ tr/ATGC/TACG/;
            $seq = reverse $seq;
            $hash_seq{$gene_id} -> {$trans_id} = $seq.$hash_seq{$gene_id} -> {$trans_id};
        }else{
            $hash_seq{$gene_id} -> {$trans_id} .= $seq;
        }
    }
}

foreach my $gene_id (keys %hash_seq){
    foreach my $trans_id(keys %{$hash_seq{$gene_id}}){
        my $fa_id = "$hash_trans{$gene_id}:$trans_id";
        my $seq = $hash_seq{$gene_id} -> {$trans_id};
        print ">$fa_id\n$seq\n";
    }
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Genome seq> <imp cuff trans> < cuff cmp GTF>
DIE
}
